const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const fs = require('fs')

const serviceAccount = require('./config/firebase_credentials.json');

class Import {

    #db
    #countries = []
    #cities = []

    constructor(firebaseAccount) {
        initializeApp({
            credential: cert(firebaseAccount)
        });
          
        this.#db = getFirestore();
    }

    async parser(csvPath) {

        const csvParse = require('csv-parse/sync')

        const file = fs.readFileSync(csvPath, 'utf8');

        const records = csvParse.parse(
            file,
            {
                columns: true,
                trim: true
            }
        )
    
        await Promise.all([
            this.parserCountries(records),
            this.parserCities(records),
        ])

        return this
    }

    async parserCountries(records) {
        this.#countries = records
            .map( record => record.country )
            .sort((a, b) => a - b)
            // Unique
            .filter((value, index, self) =>  self.indexOf(value) === index)
            .map(
                country => ({
                    name: country
                })
            )            
        
        return this.#countries
    }

    async parserCities(records) {
        this.#cities = records
    }

    async batch(collectionName, items){
        const batch = this.#db.batch()

        items.forEach(
            item => {
                const doc = this.#db.collection(collectionName).doc()

                batch.create(doc, item)
            }
        )

        return batch.commit()
            .then(console.log)
    }

    async upload() {

        const limit = 500

        console.log('countries: %d', this.#countries.length)

        for (let i = 0; i < this.#countries.length; i += limit) {
            const chunk = this.#countries.slice(i, i + limit)

            await this.batch(
                'country',
                chunk.map(
                    country => ({
                        name: country.name
                    })
                )
            )
        }

        for (let i = 0; i < this.#cities.length; i += limit) {
            const chunk = this.#cities.slice(i, i + limit)

            await this.batch(
                'city',
                chunk.map(
                    city => ({
                        name: city.name,
                        country: city.country,
                        geonameid: city.geonameid
                    })
                )
            )
        }

        console.log('\nSuccess!\n')

        process.exit(0)
    }

}

const runner = new Import(
    serviceAccount
)

runner
    .parser('world-cities.csv')
    .then(() => runner.upload())
