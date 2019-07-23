# Rails FedEx Clone

FedEx Clone is a evaluations project of Codeable build with Rails and love. The requirements and scope of the project are [here](https://github.com/codeableorg/rails-fedex-clon/blob/master/requirements.md). 

Deploy in [Heroku](https://codeable-rails-fedex-clon.herokuapp.com/)

## Team

- [Diego Torres - Tech Lead](https://github.com/diegotc86)
- [Brayan Ciudad](https://github.com/Linzeur)
- [Angie Gonzales](https://github.com/AngieCristina)
- [Carlos Sandoval](https://github.com/cdsandoval)
- [Paul Portillo](https://github.com/yummta)

## Installation

- Clone repository and go to the project
- Create a .env file in the root path of the project and copy all content of file .env.example and set your credentials. Follow the instructions in the file.
- Excute bundle to install all gems
  ```bash
  bundle install
  ```
- Setup your Database
  ```bash
  rails db:create
  rails db:migrate
  rails db:seed
  ```
- Start server

  ```bash
  rails s
  ```

- Go to http://localhost:3000

- Welcome to the FedEx Clone :)

## Documentation about API:

| Verb  | Endpoint                                     | Description                                                        |
| ----- | -------------------------------------------- | ------------------------------------------------------------------ |
| GET   | /api/login                                   | Get a web token to use in queries                                  |
| GET   | /api/shipments/search                        | Search the shipments identified by their tracking_number           |
| GET   | /api/deposit/shipments/search(.:format)      | Search the shipments identified by their tracking_number           |
| GET   | /api/deposit/shipment_locations/history      | Obtain an history about different locations of store of a shipment |
| POST  | /api/deposit/shipment_locations              | Create shipment location                                           |
| GET   | /api/admin/sales/report_countries_recipients | Obtain report about top countries recipients                       |
| GET   | /api/admin/sales/report_countries_senders    | Obtain report about top countries senders                          |
| GET   | /api/admin/sales/report_packages_sents       | Obtain report about most sender with packaged sents                |
| GET   | /api/admin/sales/report_freight_sents        | Obtain report about most freight value sents                       |
| GET   | /api/admin/shipments/search                  | Search the shipments identified by their tracking_number           |
| POST  | /api/admin/shipments                         | Create shipment                                                    |
| PATCH | /api/admin/shipments/:id                     | Update a shipment                                                  |
| PUT   | /api/admin/shipments/:id                     | Update a shipment                                                  |
| POST  | /api/admin/users                             | Create a user                                                      |


