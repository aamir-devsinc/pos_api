# POS API
  point of sales api by devsinc.

## System Requirements

* Ruby version  2.6.3
* Rails version  5.2.3
* PostgreSQL    11.4

## Getting Started
* Clone repo and open project folder from terminal
    * `git clone https://github.com/aamir-devsinc/pos_api.git`
    * cd `pos_api`
* Run `bundle install` to install all dependencies
* Update DB credentials in `config/database.yml` file
* Setup database
    *  Run `rake db:create`
    *  Run `rake db:migrate`
* Add `127.0.0.1 lvh.me` in `hosts` file
* Run server `rails s `

### First Time Use
  *Create Company
    * Open rails console
      * run Company.create(name:"devsinc",subdomain:"devsinc")
    * Next read documentation of front end from
      `https://github.com/aamir-devsinc/pos_web.git`
## Built With
*  [devise_token_auth][1.1.0]
*  [apartment][2.2.1]

✌️🍆
