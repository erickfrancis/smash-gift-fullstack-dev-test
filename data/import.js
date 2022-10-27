const { initializeApp, applicationDefault, cert } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');

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
        await Promise.all([
            this.parserCountries(csvPath),
            this.parserCities(csvPath),
        ])

        return this
    }

    async parserCountries(csvPath) {
        this.#countries.push({
            name: 'Brazil'
        })
    }

    async parserCities(csvPath) {
        this.#cities.push({
            name: 'Brasília',
            country: 'Brazil',
            geonameid: 123
        })
    }

    async upload() {
        const batch = this.#db.batch()

        const countryDb = this.#db.collection('country')

        this.#countries.forEach(
            country => {
                const doc = countryDb.doc()
                batch.set(doc, {
                    name: country.name
                })
            }
        )

        const cityDb = this.#db.collection('city')

        this.#cities.forEach(
            city => {
                const doc = cityDb.doc()
                batch.set(doc, {
                    name: city.name,
                    country: city.country,
                    geonameid: city.geonameid
                })
            }
        )

        return batch.commit()
            .then(() => {
                console.log('\nSuccess!\n')

                process.exit(0)
            })
    }
}

const runner = new Import(
    serviceAccount
)

runner
    .parser('world-cities.csv')
    .then(() => runner.upload())
