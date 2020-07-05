# README
test2
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
---------------------------------------
## Usersテーブル

|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false, unique: true, index: true|
|password|string|null: false, unique: true, index: true|
|family_name|string|null: false|
|given_name|string|null: false|
|family_name_kana|string|null: false|
|given_name_kana|string|null: false|
|birthday|data|null: false|

### Association
- has_one :profileaddress, dependent: :destroy
- has_one :creditcard, dependent: :destroy 
- has_one :deliveryaddress, dependent: :destroy
- has_many :evaluations, dependent: :delete_all
- has_many :products, dependent: :delete_all
- has_many :comments, dependent: :delete_all

---------------------------------------

---------------------------------------
## Profileaddressesテーブル

|Column|Type|Options|
|------|----|-------|
|postal_code|string|null|
|prefectures|string|null|
|city|string|null|
|address|string|null|
|building|string|null|
|user_id|references|foreign_key: true|

### Association
- belongs_to :user

---------------------------------------

---------------------------------------
## Creditcardsテーブル

|Column|Type|Options|
|------|----|-------|
|customer_id|string|null: false|
|card_id|string|null: false|
|user_id|references|foreign_key: true|

### Association
- belongs_to :user
---------------------------------------

---------------------------------------
## Deliveryaddressesテーブル

|Column|Type|Options|
|------|----|-------|
|family_name|string|null: false|
|given_name|string|null: false|
|family_name_kana|string|null: false|
|given_name_kana|string|null: false|
|postal_code|string|null: false|
|prefectures|string|null: false|
|city|string|null: false|
|address|string|null: false|
|building|string|null|
|phone_number|string|null|
|user_id|references|foreign_key: true|

### Association
- belongs_to :user
---------------------------------------

---------------------------------------
## Evaluationsテーブル

|Column|Type|Options|
|------|----|-------|
|evaluation|string|null: false|
|user_id|references|foreign_key: true|

### Association
- belongs_to :user
---------------------------------------

---------------------------------------
## Productsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|explanation|text|null: false|
|category|references|null: false, foreign_key: true|
|brand|string|null|
|product_status|integer|null: false|
|delivery_cost|integer|null: false|
|shipping_origin|integer|null: false|
|delivery_day|integer|null: false|
|price|integer|null: false|
|user_id|references|null: false, foreign_key: true|
|buyer|integer|null|

### Association
- belongs_to :user
- belongs_to :category
- belongs_to :brand
- has_many :images, dependent: :delete_all
- has_many :comments, dependent: :delete_all
---------------------------------------

---------------------------------------
## Imagesテーブル

|Column|Type|Options|
|------|----|-------|
|image|string|null: false|
|product_id|references|null: false, foreign_key: true|

### Association
- belongs_to :product
---------------------------------------

---------------------------------------
## Categoriesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|index: true|

### Association
- has_many :products
---------------------------------------

---------------------------------------
## Brandsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|

### Association
- has_many :products
---------------------------------------

---------------------------------------
## Commentsテーブル

|Column|Type|Options|
|------|----|-------|
|comment|text|null: false|
|user_id|string|foreign_key: true|
|product_id|references|foreign_key: true|

### Association
- belongs_to :product
- belongs_to :user
---------------------------------------