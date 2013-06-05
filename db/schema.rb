# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130530201615) do

  create_table "Sheet1", :id => false, :force => true do |t|
    t.string "Source",           :null => false
    t.string "Biz_Name",         :null => false
    t.string "Biz_Street",       :null => false
    t.string "Billing_City",     :null => false
    t.string "Billing_State",    :null => false
    t.string "Billing_Zip_Code", :null => false
    t.string "Phone",            :null => false
    t.string "Phone2",           :null => false
    t.string "Website",          :null => false
    t.string "Email",            :null => false
    t.string "Value",            :null => false
    t.string "URL",              :null => false
  end

  create_table "Yip_Dupe", :id => false, :force => true do |t|
    t.string "ID",               :null => false
    t.string "Date_Added",       :null => false
    t.string "Date_Ended",       :null => false
    t.string "Site",             :null => false
    t.string "Full_Title",       :null => false
    t.string "Short_Title",      :null => false
    t.string "Price",            :null => false
    t.string "Value",            :null => false
    t.string "Discount",         :null => false
    t.string "Sold",             :null => false
    t.string "Sold_Out",         :null => false
    t.string "Revenue",          :null => false
    t.string "Rev_Index",        :null => false
    t.string "Merchant_ID",      :null => false
    t.string "Merchant_Name",    :null => false
    t.string "Address",          :null => false
    t.string "City",             :null => false
    t.string "Zip_Code",         :null => false
    t.string "Latitude",         :null => false
    t.string "Longitude",        :null => false
    t.string "Phone",            :null => false
    t.string "Phone_Scrub",      :null => false
    t.string "Merchant_Website", :null => false
    t.string "Category",         :null => false
    t.string "Appearances",      :null => false
    t.string "Deal_URL",         :null => false
    t.string "Yipit_URL",        :null => false
    t.string "Division",         :null => false
  end

  create_table "address_versions", :force => true do |t|
    t.integer  "address_id"
    t.integer  "version"
    t.string   "address_name"
    t.string   "street_line_1",        :limit => 100
    t.string   "street_line_2",        :limit => 100
    t.string   "city"
    t.string   "state",                :limit => 2,   :default => "NY"
    t.string   "zip",                  :limit => 5
    t.string   "zip_plus_4",           :limit => 10
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "email",                :limit => 100
    t.string   "cross_streets",        :limit => 150
    t.integer  "street_descriptor_id"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.boolean  "is_frozen"
    t.boolean  "is_approved"
    t.integer  "zone_id"
  end

  add_index "address_versions", ["address_id", "version"], :name => "unique_address_versions", :unique => true
  add_index "address_versions", ["is_approved", "is_frozen"], :name => "address_versions_approved_frozen"

  create_table "addresses", :force => true do |t|
    t.string   "address_name"
    t.string   "street_line_1",              :limit => 100
    t.string   "street_line_2",              :limit => 100
    t.string   "city"
    t.string   "state",                      :limit => 2,   :default => "NY"
    t.string   "zip",                        :limit => 5
    t.string   "zip_plus_4",                 :limit => 10
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "email",                      :limit => 100
    t.string   "cross_streets",              :limit => 150
    t.integer  "street_descriptor_id"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.boolean  "is_frozen"
    t.boolean  "is_approved"
    t.integer  "version"
    t.integer  "latest_approved_version_id"
    t.integer  "zone_id"
  end

  add_index "addresses", ["addressable_type", "addressable_id"], :name => "index_addresses_on_addressable_type_and_addressable_id"

  create_table "addresses_audit", :force => true do |t|
    t.integer   "addresses_id"
    t.string    "address_name"
    t.string    "street_line_1",              :limit => 100
    t.string    "street_line_2",              :limit => 100
    t.string    "city"
    t.string    "state",                      :limit => 2,   :default => "NY"
    t.string    "zip",                        :limit => 5
    t.string    "zip_plus_4",                 :limit => 10
    t.timestamp "updated_at",                                                  :null => false
    t.timestamp "created_at",                                                  :null => false
    t.string    "email",                      :limit => 100
    t.string    "cross_streets",              :limit => 150
    t.integer   "street_descriptor_id"
    t.integer   "addressable_id"
    t.string    "addressable_type"
    t.binary    "is_frozen",                  :limit => 1
    t.binary    "is_approved",                :limit => 1
    t.integer   "version"
    t.integer   "latest_approved_version_id"
    t.integer   "zone_id"
  end

  create_table "admin_users", :force => true do |t|
    t.string   "login",                :limit => 80
    t.string   "old_user_name",        :limit => 100
    t.string   "old_crypted_password", :limit => 40
    t.string   "old_salt",             :limit => 40,  :default => ""
    t.integer  "user_type",                           :default => 0
    t.datetime "activated_at",                        :default => '1969-12-31 19:00:00'
    t.integer  "lb_city_enum_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email"
  add_index "admin_users", ["old_user_name"], :name => "user_name"

  create_table "alert_queues", :force => true do |t|
    t.integer  "alert_type_id"
    t.integer  "booking_id"
    t.datetime "sent_date"
  end

  create_table "alert_styles", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.integer  "is_disabled"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "alert_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "alert_style_id"
    t.integer  "is_disabled"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "asset_block_practitioners", :force => true do |t|
    t.integer "asset_block_id"
    t.integer "service_provider_resource_id"
  end

  add_index "asset_block_practitioners", ["asset_block_id", "service_provider_resource_id"], :name => "asset_block_id", :unique => true
  add_index "asset_block_practitioners", ["service_provider_resource_id"], :name => "service_provider_resource_id"

  create_table "asset_block_state_changes", :force => true do |t|
    t.integer  "asset_block_id"
    t.string   "service_provider"
    t.string   "asset_block_type"
    t.string   "action"
    t.integer  "start_time"
    t.integer  "end_time"
    t.string   "asset_ids"
    t.string   "wdays"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "discounts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",     :default => 0, :null => false
    t.integer  "created_by_id"
    t.string   "created_by_type"
  end

  create_table "asset_blocks", :force => true do |t|
    t.integer  "block_type",          :default => 0
    t.integer  "spaces_left"
    t.string   "provider_note"
    t.text     "extra_data"
    t.integer  "lock_version",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "service_provider_id"
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.integer  "rolling_discount_id"
  end

  add_index "asset_blocks", ["block_type"], :name => "block_type"
  add_index "asset_blocks", ["rolling_discount_id"], :name => "index_asset_blocks_on_rolling_discount_id"
  add_index "asset_blocks", ["service_provider_id", "type", "id"], :name => "service_provider_id"
  add_index "asset_blocks", ["type"], :name => "type"

  create_table "asset_blocks_service_availabilities", :id => false, :force => true do |t|
    t.integer "asset_block_id"
    t.integer "service_availability_id"
  end

  add_index "asset_blocks_service_availabilities", ["asset_block_id", "service_availability_id"], :name => "absa_compound", :unique => true
  add_index "asset_blocks_service_availabilities", ["asset_block_id"], :name => "absa_ab_id"
  add_index "asset_blocks_service_availabilities", ["service_availability_id"], :name => "absa_sa_id"

  create_table "async_workers", :force => true do |t|
    t.string   "name"
    t.boolean  "available"
    t.integer  "assigned_to"
    t.integer  "processing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
    t.string   "type"
  end

  create_table "balance_transfers", :force => true do |t|
    t.integer  "from_invoice_id"
    t.integer  "to_invoice_id"
    t.decimal  "amount",          :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                   :default => 0, :null => false
  end

  create_table "booking_service_provider_resources", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "service_provider_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 :default => 0, :null => false
  end

  add_index "booking_service_provider_resources", ["booking_id", "service_provider_resource_id"], :name => "bspr_booking_id"
  add_index "booking_service_provider_resources", ["service_provider_resource_id", "booking_id"], :name => "bspr_spr_id"

  create_table "booking_state_changes", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "from_state"
    t.integer  "to_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "to"
    t.string   "from"
  end

  add_index "booking_state_changes", ["booking_id"], :name => "index_booking_state_changes_on_booking_id"
  add_index "booking_state_changes", ["updated_at", "created_at", "booking_id"], :name => "updated_at"

  create_table "bookings", :force => true do |t|
    t.integer  "client_id"
    t.integer  "service_provider_resource_id"
    t.integer  "service_provider_service_id"
    t.datetime "appt_time"
    t.integer  "duration"
    t.integer  "price"
    t.integer  "state_id"
    t.boolean  "notify_via_sms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sp_id"
    t.boolean  "is_active"
    t.float    "service_charge"
    t.boolean  "is_charge_sp"
    t.float    "rating"
    t.text     "rating_blurb"
    t.datetime "last_alert"
    t.integer  "reason_id"
    t.text     "reason_blurb"
    t.integer  "unavailability_id"
    t.integer  "lock_version",                                           :default => 0
    t.string   "rating_title",                            :limit => 100
    t.integer  "customer_provider_history_type_id"
    t.datetime "booked_at"
    t.float    "discount_amt"
    t.integer  "asset_block_id"
    t.integer  "locked_gender"
    t.integer  "locked_practitioner"
    t.string   "client_notes",                            :limit => 200
    t.integer  "cartable_sp_service_id"
    t.integer  "referring_source_id"
    t.datetime "last_alert_support"
    t.integer  "last_alert_sp_count",                                    :default => 0
    t.float    "no_show_charge_amount",                                  :default => 0.0
    t.float    "late_cancellation_charge_amount",                        :default => 0.0
    t.integer  "cancellation_period"
    t.float    "late_cancellation_service_charge_amount",                :default => 0.0
    t.float    "no_show_service_charge_amount",                          :default => 0.0
    t.string   "referring_source_sub_id"
    t.float    "selected_price"
    t.integer  "cart_item_id"
    t.float    "price_to_charge"
    t.integer  "last_phone_alert_sp_count",                              :default => 0
    t.text     "client_dispute_notes"
    t.integer  "break_asset_block_id"
    t.string   "remote_booking_id"
    t.integer  "tracking_source_id"
    t.string   "state"
    t.datetime "last_transition_time"
    t.integer  "city_id"
    t.integer  "potential_rewards"
    t.boolean  "sent_rating_reminder",                                   :default => false
    t.boolean  "sent_customer_reminder",                                 :default => false
    t.string   "full_name"
  end

  add_index "bookings", ["appt_time"], :name => "index_bookings_on_appt_time"
  add_index "bookings", ["asset_block_id"], :name => "asset_block_id"
  add_index "bookings", ["booked_at"], :name => "index_bookings_on_booked_at"
  add_index "bookings", ["cart_item_id"], :name => "index_bookings_on_cart_item_id"
  add_index "bookings", ["cartable_sp_service_id"], :name => "cartable_sp_service_id"
  add_index "bookings", ["client_id", "state_id"], :name => "client_id"
  add_index "bookings", ["client_id"], :name => "index_bookings_on_client_id"
  add_index "bookings", ["rating"], :name => "index_bookings_on_rating"
  add_index "bookings", ["remote_booking_id"], :name => "index_bookings_on_remote_booking_id"
  add_index "bookings", ["service_provider_service_id", "sp_id", "created_at"], :name => "service_provider_service_id"
  add_index "bookings", ["service_provider_service_id"], :name => "index_bookings_on_service_provider_service_id"
  add_index "bookings", ["sp_id"], :name => "sp_id"
  add_index "bookings", ["state", "appt_time"], :name => "index_bookings_on_state_and_appt_time"
  add_index "bookings", ["state", "client_id"], :name => "index_bookings_on_state_and_client_id"
  add_index "bookings", ["state_id", "appt_time"], :name => "state_id"
  add_index "bookings", ["tracking_source_id"], :name => "index_bookings_on_tracking_source_id"

  create_table "buck_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "bucks", :force => true do |t|
    t.float    "value"
    t.integer  "state_id"
    t.datetime "awarded_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "client_id"
    t.integer  "booking_id"
    t.integer  "booking_committed_to_id"
    t.integer  "lock_version",            :default => 0
    t.string   "memo"
    t.integer  "buck_type_id"
  end

  add_index "bucks", ["booking_committed_to_id"], :name => "booking_committed_to_id"
  add_index "bucks", ["booking_id"], :name => "booking_id"

  create_table "business_types", :force => true do |t|
    t.string   "business_type", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                   :default => true
  end

  create_table "calendar_tasks", :force => true do |t|
    t.string   "task_method"
    t.binary   "task_object",    :limit => 2147483647
    t.boolean  "is_new",                               :default => true
    t.datetime "created_at"
    t.integer  "group_id"
    t.string   "worker_id"
    t.binary   "task_arguments", :limit => 2147483647
    t.text     "description"
  end

  create_table "cancellation_policies", :force => true do |t|
    t.integer  "service_provider_id"
    t.float    "value"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "charge_type_id"
  end

  add_index "cancellation_policies", ["service_provider_id"], :name => "index_cancellation_policies_on_service_provider_id"

  create_table "cart_item_cartables", :force => true do |t|
    t.integer "cart_item_id"
    t.integer "cartable_id"
    t.string  "cartable_type"
  end

  add_index "cart_item_cartables", ["cart_item_id", "cartable_id", "cartable_type"], :name => "cart_item_id"
  add_index "cart_item_cartables", ["cartable_id", "cart_item_id"], :name => "cartable_id"

  create_table "cart_item_service_provider_resources", :force => true do |t|
    t.integer  "cart_item_id"
    t.integer  "service_provider_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 :default => 0, :null => false
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id"
    t.datetime "checkout_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",                        :limit => 36
    t.date     "minimum_date_filter"
    t.date     "maximum_date_filter"
    t.integer  "minimum_time_filter"
    t.integer  "maximum_time_filter"
    t.integer  "minimum_discount_filter"
    t.integer  "maximum_discount_filter"
    t.datetime "selected_time"
    t.integer  "guests"
    t.string   "special_request"
    t.float    "selected_price"
    t.integer  "gender_filter"
    t.string   "selected_sp_name"
    t.string   "selected_service_name"
    t.integer  "selected_duration"
    t.integer  "service_provider_service_id"
    t.integer  "master_cart_item_id"
    t.integer  "orig_price"
    t.integer  "selected_discount"
    t.integer  "selected_gender"
    t.integer  "selected_practitioner_id"
    t.string   "type",                                      :default => "CartItem"
  end

  add_index "cart_items", ["cart_id", "master_cart_item_id"], :name => "cart_id"
  add_index "cart_items", ["master_cart_item_id"], :name => "master_cart_item_id"

  create_table "carts", :force => true do |t|
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checkout_at"
    t.boolean  "use_reward_dollars", :default => true
  end

  add_index "carts", ["client_id", "checkout_at"], :name => "client_id"

  create_table "cheques", :force => true do |t|
    t.float    "amount"
    t.string   "cheque_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0, :null => false
    t.string   "type"
  end

  add_index "cheques", ["type"], :name => "index_cheques_on_type"

  create_table "client_audit", :force => true do |t|
    t.integer   "clients_id"
    t.string    "email",                              :limit => 100
    t.string    "old_crypted_password",               :limit => 40
    t.string    "old_salt",                           :limit => 40
    t.string    "activation_code",                    :limit => 40
    t.timestamp "activated_at",                                                          :null => false
    t.string    "first_name",                         :limit => 100
    t.string    "last_name",                          :limit => 100
    t.string    "hotel_business",                     :limit => 150
    t.string    "phone",                              :limit => 30
    t.integer   "address_id"
    t.string    "email_secondary",                    :limit => 100
    t.integer   "salutation_id"
    t.string    "city_of_birth",                      :limit => 100
    t.date      "date_of_birth"
    t.binary    "accept_promo_emails",                :limit => 1
    t.binary    "accept_email_alert",                 :limit => 1
    t.binary    "accept_sms_alert",                   :limit => 1
    t.binary    "cancel_flag",                        :limit => 1
    t.binary    "inform_establishments_flag",         :limit => 1,   :default => "b'0'"
    t.binary    "zip_default_flag",                   :limit => 1,   :default => "b'0'"
    t.timestamp "canceled_at",                                                           :null => false
    t.timestamp "user_modified_at",                                                      :null => false
    t.timestamp "created_at",                                                            :null => false
    t.timestamp "updated_at",                                                            :null => false
    t.binary    "is_concierge",                       :limit => 1,   :default => "b'0'"
    t.integer   "is_active",                                         :default => 1
    t.string    "mobile_number",                      :limit => 50
    t.integer   "mobile_carrier_id"
    t.string    "login_token",                        :limit => 40
    t.binary    "confirm_legal_flag",                 :limit => 1,   :default => "b'0'"
    t.integer   "bucks_value"
    t.integer   "credit_card_id"
    t.integer   "user_type",                                         :default => 2
    t.string    "old_user_name",                      :limit => 100
    t.integer   "shipping_address_id"
    t.binary    "accept_product_giveaway",            :limit => 1,   :default => "b'0'"
    t.integer   "client_profile_id"
    t.integer   "lb_city_enum_id"
    t.binary    "signed_up",                          :limit => 1,   :default => "b'0'"
    t.string    "braintree_customer_id"
    t.date      "reward_dollar_expiration_date"
    t.string    "facebook_id"
    t.string    "unique_url"
    t.integer   "gender_id"
    t.date      "birthdate"
    t.integer   "referring_source_id"
    t.integer   "signup_session_referring_source_id"
    t.string    "aasm_state"
    t.integer   "reward_code_id"
    t.integer   "tracking_source_id"
    t.integer   "signup_tracking_source_id"
  end

  create_table "client_postal_codes", :force => true do |t|
    t.integer  "client_id"
    t.integer  "postal_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
  end

  add_index "client_postal_codes", ["client_id", "postal_code_id"], :name => "client_id"
  add_index "client_postal_codes", ["postal_code_id", "client_id"], :name => "postal_code_id"

  create_table "client_profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_referral_id"
    t.string   "client_referral_description"
    t.integer  "lb_city_enum_id"
    t.integer  "pagination_size",             :default => 50
    t.integer  "referring_source_id"
    t.string   "referring_source_sub_id"
    t.integer  "zone_id"
  end

  create_table "client_provider_booking_counts", :force => true do |t|
    t.integer  "client_id"
    t.integer  "provider_id"
    t.integer  "count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "client_provider_booking_counts", ["client_id", "provider_id"], :name => "unq_client_id_provider_id", :unique => true

  create_table "client_rated_reviews", :force => true do |t|
    t.integer  "client_id"
    t.integer  "client_review_id"
    t.boolean  "is_helpful"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_rated_reviews", ["client_review_id"], :name => "client_review_id"

  create_table "client_referrals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                :default => true
    t.string   "name",       :limit => 40,                   :null => false
    t.string   "short_name", :limit => 20
    t.string   "value",      :limit => 20
  end

  create_table "client_reviews", :force => true do |t|
    t.integer  "review_source_id"
    t.text     "client_name"
    t.string   "full_name"
    t.text     "body"
    t.integer  "helpfulness",         :default => 0
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_featured",         :default => false
    t.boolean  "is_pending_featured", :default => true
    t.string   "review_source_type"
    t.string   "reviewed_type"
    t.integer  "reviewed_id"
    t.integer  "service_provider_id"
    t.integer  "client_id"
    t.float    "rating"
    t.datetime "appointment_time"
  end

  add_index "client_reviews", ["client_id"], :name => "index_client_reviews_on_client_id"
  add_index "client_reviews", ["is_active", "is_featured"], :name => "index_client_reviews_active_featured"
  add_index "client_reviews", ["is_active", "reviewed_type", "reviewed_id"], :name => "is_active"
  add_index "client_reviews", ["is_active"], :name => "index_client_reviews_on_is_active"
  add_index "client_reviews", ["rating"], :name => "index_client_reviews_on_rating"
  add_index "client_reviews", ["review_source_id"], :name => "booking_id"
  add_index "client_reviews", ["review_source_type", "review_source_id"], :name => "index_client_reviews_on_review_source_type_and_review_source_id", :unique => true
  add_index "client_reviews", ["reviewed_type", "reviewed_id"], :name => "index_client_reviews_on_reviewed_type_and_reviewed_id"
  add_index "client_reviews", ["service_provider_id", "is_active", "reviewed_type", "reviewed_id"], :name => "service_provider_id"
  add_index "client_reviews", ["service_provider_id", "is_active", "reviewed_type", "reviewed_id"], :name => "service_provider_id_2"
  add_index "client_reviews", ["service_provider_id"], :name => "index_client_reviews_on_service_provider_id"

  create_table "client_reward_codes", :force => true do |t|
    t.string   "reward_code_id"
    t.integer  "client_id"
    t.integer  "booking_id"
    t.datetime "redeemed_date"
    t.integer  "is_active",      :default => 1
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "client_service_categories", :force => true do |t|
    t.integer  "client_id"
    t.integer  "service_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
  end

  add_index "client_service_categories", ["client_id", "service_category_id"], :name => "client_id_sc_id"

  create_table "client_transactions", :force => true do |t|
    t.integer  "client_id"
    t.integer  "gift_certificate_id"
    t.float    "value"
    t.datetime "cleared_at"
    t.string   "tran_ref_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "booking_id"
    t.boolean  "created_by_admin",    :default => false
    t.datetime "reversed_at"
  end

  add_index "client_transactions", ["booking_id"], :name => "index_client_transactions_on_booking_id"

  create_table "client_waiting_lists", :force => true do |t|
    t.integer  "client_id"
    t.integer  "waiting_list_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0, :null => false
    t.integer  "loot_id"
  end

  add_index "client_waiting_lists", ["waiting_list_id", "client_id", "is_active"], :name => "waiting_list_id"
  add_index "client_waiting_lists", ["waiting_list_id", "loot_id", "is_active"], :name => "waiting_list_id_2"

  create_table "client_zones", :force => true do |t|
    t.integer  "client_id"
    t.float    "value"
    t.string   "product_type"
    t.integer  "product_id"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "client_zones", ["client_id", "zone_id"], :name => "index_client_zones_on_client_id_and_zone_id"
  add_index "client_zones", ["product_type", "product_id"], :name => "index_client_zones_on_product_type_and_product_id"

  create_table "clients", :force => true do |t|
    t.string   "email",                              :limit => 100
    t.string   "old_crypted_password",               :limit => 40
    t.string   "old_salt",                           :limit => 40
    t.string   "activation_code",                    :limit => 40
    t.datetime "activated_at"
    t.string   "first_name",                         :limit => 100
    t.string   "last_name",                          :limit => 100
    t.string   "hotel_business",                     :limit => 150
    t.string   "phone",                              :limit => 30
    t.integer  "address_id"
    t.string   "email_secondary",                    :limit => 100
    t.integer  "salutation_id"
    t.string   "city_of_birth",                      :limit => 100
    t.date     "date_of_birth"
    t.boolean  "accept_promo_emails"
    t.boolean  "accept_email_alert"
    t.boolean  "accept_sms_alert"
    t.boolean  "cancel_flag"
    t.boolean  "inform_establishments_flag",                        :default => false
    t.boolean  "zip_default_flag",                                  :default => false
    t.datetime "canceled_at"
    t.datetime "user_modified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_concierge",                                      :default => false
    t.integer  "is_active",                                         :default => 1
    t.string   "mobile_number",                      :limit => 50
    t.integer  "mobile_carrier_id"
    t.string   "login_token",                        :limit => 40
    t.boolean  "confirm_legal_flag",                                :default => false
    t.integer  "bucks_value"
    t.integer  "credit_card_id"
    t.integer  "user_type",                                         :default => 2
    t.string   "old_user_name",                      :limit => 100
    t.integer  "shipping_address_id"
    t.boolean  "accept_product_giveaway",                           :default => false
    t.integer  "client_profile_id"
    t.integer  "lb_city_enum_id"
    t.boolean  "signed_up",                                         :default => false
    t.string   "braintree_customer_id"
    t.date     "reward_dollar_expiration_date"
    t.string   "facebook_id",                                       :default => ""
    t.string   "unique_url"
    t.integer  "gender_id"
    t.date     "birthdate"
    t.integer  "referring_source_id"
    t.integer  "signup_session_referring_source_id"
    t.string   "aasm_state"
    t.integer  "reward_code_id"
    t.integer  "tracking_source_id"
    t.integer  "signup_tracking_source_id"
  end

  add_index "clients", ["aasm_state"], :name => "index_clients_on_aasm_state"
  add_index "clients", ["email"], :name => "client_email", :unique => true
  add_index "clients", ["email"], :name => "index_clients_on_email"
  add_index "clients", ["id", "lb_city_enum_id"], :name => "id"
  add_index "clients", ["lb_city_enum_id", "created_at", "id"], :name => "lb_city_enum_id"
  add_index "clients", ["old_user_name"], :name => "user_name", :unique => true
  add_index "clients", ["referring_source_id", "created_at"], :name => "index_clients_on_referring_source_id_and_created_at"
  add_index "clients", ["signup_tracking_source_id"], :name => "index_clients_on_signup_tracking_source_id"
  add_index "clients", ["tracking_source_id"], :name => "index_clients_on_tracking_source_id"
  add_index "clients", ["unique_url"], :name => "index_clients_on_unique_url", :unique => true

  create_table "clients_audit", :force => true do |t|
    t.integer   "clients_id"
    t.string    "email",                              :limit => 100
    t.string    "old_crypted_password",               :limit => 40
    t.string    "old_salt",                           :limit => 40
    t.string    "activation_code",                    :limit => 40
    t.timestamp "activated_at",                                                          :null => false
    t.string    "first_name",                         :limit => 100
    t.string    "last_name",                          :limit => 100
    t.string    "hotel_business",                     :limit => 150
    t.string    "phone",                              :limit => 30
    t.integer   "address_id"
    t.string    "email_secondary",                    :limit => 100
    t.integer   "salutation_id"
    t.string    "city_of_birth",                      :limit => 100
    t.date      "date_of_birth"
    t.binary    "accept_promo_emails",                :limit => 1
    t.binary    "accept_email_alert",                 :limit => 1
    t.binary    "accept_sms_alert",                   :limit => 1
    t.binary    "cancel_flag",                        :limit => 1
    t.binary    "inform_establishments_flag",         :limit => 1,   :default => "b'0'"
    t.binary    "zip_default_flag",                   :limit => 1,   :default => "b'0'"
    t.timestamp "canceled_at",                                                           :null => false
    t.timestamp "user_modified_at",                                                      :null => false
    t.timestamp "created_at",                                                            :null => false
    t.timestamp "updated_at",                                                            :null => false
    t.binary    "is_concierge",                       :limit => 1,   :default => "b'0'"
    t.integer   "is_active",                                         :default => 1
    t.string    "mobile_number",                      :limit => 50
    t.integer   "mobile_carrier_id"
    t.string    "login_token",                        :limit => 40
    t.binary    "confirm_legal_flag",                 :limit => 1,   :default => "b'0'"
    t.integer   "bucks_value"
    t.integer   "credit_card_id"
    t.integer   "user_type",                                         :default => 2
    t.string    "old_user_name",                      :limit => 100
    t.integer   "shipping_address_id"
    t.binary    "accept_product_giveaway",            :limit => 1,   :default => "b'0'"
    t.integer   "client_profile_id"
    t.integer   "lb_city_enum_id"
    t.binary    "signed_up",                          :limit => 1,   :default => "b'0'"
    t.string    "braintree_customer_id"
    t.date      "reward_dollar_expiration_date"
    t.string    "facebook_id"
    t.string    "unique_url"
    t.integer   "gender_id"
    t.date      "birthdate"
    t.integer   "referring_source_id"
    t.integer   "signup_session_referring_source_id"
    t.string    "aasm_state"
    t.integer   "reward_code_id"
    t.integer   "tracking_source_id"
    t.integer   "signup_tracking_source_id"
  end

  create_table "contest_codes", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "current_uses"
    t.integer  "max_uses"
    t.string   "title"
    t.text     "blurb"
    t.text     "rules"
    t.text     "post_registration_blurb"
    t.binary   "image_file_data",         :limit => 16777215
    t.string   "lb_admin_notes"
    t.boolean  "is_active"
    t.integer  "lock_version",                                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "contest_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counters", :force => true do |t|
    t.string   "name"
    t.integer  "count"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "credit_card_types", :force => true do |t|
    t.string   "name",        :limit => 35
    t.string   "short_name",  :limit => 20
    t.datetime "created_at"
    t.datetime "modified_at"
    t.string   "long_name"
  end

  create_table "credit_cards", :force => true do |t|
    t.date     "expiration_date"
    t.integer  "billing_address_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "credit_card_type_id"
    t.boolean  "is_active",                              :default => true
    t.string   "first_name",              :limit => 100
    t.string   "last_name",               :limit => 100
    t.string   "obscured_account_number"
    t.datetime "authorized_at"
    t.string   "braintree_token"
    t.integer  "billed_id"
    t.string   "billed_type"
    t.string   "braintree_customer_id"
    t.string   "braintree_address_id"
  end

  add_index "credit_cards", ["billed_type", "billed_id"], :name => "billed_type"

  create_table "customer_provider_histories", :force => true do |t|
    t.integer  "client_id"
    t.integer  "service_provider_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "customer_provider_history_type_id"
  end

  create_table "customer_provider_history_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "date_expressions", :force => true do |t|
    t.integer  "start_dtime"
    t.integer  "end_dtime"
    t.integer  "start_mtime"
    t.integer  "end_mtime"
    t.integer  "recurring_end_date"
    t.boolean  "is_recurring_indefinitely"
    t.integer  "frequency",                 :default => 0
    t.string   "type"
    t.integer  "dated_obj_id"
    t.string   "dated_obj_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wday"
  end

  add_index "date_expressions", ["dated_obj_type", "dated_obj_id"], :name => "de_unique", :unique => true
  add_index "date_expressions", ["dated_obj_type", "wday", "start_dtime", "end_dtime", "recurring_end_date", "is_recurring_indefinitely", "dated_obj_id"], :name => "de_search"
  add_index "date_expressions", ["frequency", "is_recurring_indefinitely"], :name => "de_compound"

  create_table "day_in_weeks", :force => true do |t|
    t.integer  "temporal_expression_id"
    t.integer  "day_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",           :default => 0, :null => false
  end

  add_index "day_in_weeks", ["temporal_expression_id", "day_index"], :name => "index_day_in_weeks_on_temporal_expression_id_and_day_index"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                        :default => 0
    t.integer  "attempts",                        :default => 0
    t.binary   "handler",     :limit => 16777215
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start"
    t.datetime "finished_at"
    t.integer  "job_id"
    t.integer  "time_taken"
    t.string   "meta_data"
  end

  add_index "delayed_jobs", ["created_at"], :name => "index_delayed_jobs_on_created_at"
  add_index "delayed_jobs", ["failed_at"], :name => "failed_at"
  add_index "delayed_jobs", ["meta_data"], :name => "meta_data"
  add_index "delayed_jobs", ["queue", "failed_at", "run_at", "finished_at", "created_at"], :name => "queue"
  add_index "delayed_jobs", ["queue"], :name => "index_delayed_jobs_on_queue"
  add_index "delayed_jobs", ["run_at", "queue", "failed_at", "finished_at"], :name => "index_delayed_jobs"
  add_index "delayed_jobs", ["run_at"], :name => "run_at"
  add_index "delayed_jobs", ["start"], :name => "start"

  create_table "discount_downs", :force => true do |t|
    t.integer  "service_provider_id"
    t.string   "name"
    t.date     "start_date"
    t.integer  "start_time"
    t.integer  "discount_interval"
    t.integer  "time_interval"
    t.integer  "starting_discount"
    t.integer  "current_discount"
    t.integer  "minimum_discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
  end

  add_index "discount_downs", ["start_date", "minimum_discount", "current_discount"], :name => "discount_downs_discounts"

  create_table "discount_downs_service_provider_services", :id => false, :force => true do |t|
    t.integer "service_provider_service_id"
    t.integer "discount_down_id"
  end

  add_index "discount_downs_service_provider_services", ["service_provider_service_id", "discount_down_id"], :name => "discount_downs_service_join"

  create_table "discounts", :force => true do |t|
    t.integer "asset_block_id"
    t.integer "service_id"
    t.float   "discount_amt"
    t.integer "asset_id"
  end

  add_index "discounts", ["asset_block_id", "asset_id"], :name => "asset_block_id"
  add_index "discounts", ["asset_block_id", "service_id"], :name => "asset_block_id_2"
  add_index "discounts", ["asset_block_id"], :name => "index_discounts_on_asset_block_id"
  add_index "discounts", ["discount_amt"], :name => "discounts_discount_amt"

  create_table "email_addresses", :force => true do |t|
    t.integer  "service_provider_id"
    t.string   "email"
    t.integer  "email_type_id"
    t.boolean  "is_active",           :default => true
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "email_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generated_codes", :force => true do |t|
    t.string   "code"
    t.integer  "loot_service_id"
    t.datetime "used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0, :null => false
  end

  add_index "generated_codes", ["code", "loot_service_id"], :name => "index_generated_codes_on_code_and_loot_service_id", :unique => true
  add_index "generated_codes", ["loot_service_id", "used_at"], :name => "index_generated_codes_on_loot_service_id_and_used_at"

  create_table "geocodes", :force => true do |t|
    t.decimal "latitude",    :precision => 15, :scale => 12
    t.decimal "longitude",   :precision => 15, :scale => 12
    t.string  "query"
    t.string  "street"
    t.string  "locality"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
    t.string  "precision"
  end

  add_index "geocodes", ["latitude"], :name => "geocodes_latitude_index"
  add_index "geocodes", ["longitude"], :name => "geocodes_longitude_index"
  add_index "geocodes", ["query"], :name => "geocodes_query_index", :unique => true

  create_table "geocodings", :force => true do |t|
    t.integer "geocodable_id"
    t.integer "geocode_id"
    t.string  "geocodable_type"
  end

  add_index "geocodings", ["geocodable_id"], :name => "geocodings_geocodable_id_index"
  add_index "geocodings", ["geocodable_type"], :name => "geocodings_geocodable_type_index"
  add_index "geocodings", ["geocode_id"], :name => "geocodings_geocode_id_index"

  create_table "gift_certificates", :force => true do |t|
    t.date     "expiration_date"
    t.date     "redeemed_date"
    t.date     "date_to_send"
    t.date     "sent_on"
    t.integer  "value"
    t.integer  "redeemed_by_id"
    t.integer  "client_id"
    t.boolean  "is_active",          :default => true
    t.string   "recipient_email"
    t.string   "notes"
    t.string   "name"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",       :default => 0,    :null => false
    t.boolean  "is_email_recipient", :default => true
  end

  create_table "hours_exceptions", :force => true do |t|
    t.integer  "service_provider_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hours_exceptions", ["end_time"], :name => "he_end_time"
  add_index "hours_exceptions", ["service_provider_id"], :name => "he_sp_id"
  add_index "hours_exceptions", ["start_time"], :name => "he_start_time"

  create_table "hours_of_operation", :force => true do |t|
    t.integer  "service_provider_id"
    t.integer  "day_of_week_id"
    t.integer  "start_time",          :default => 600
    t.integer  "end_time",            :default => 2400
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "hours_of_operation", ["day_of_week_id"], :name => "hoo_dow_id"
  add_index "hours_of_operation", ["end_time"], :name => "hoo_end_time"
  add_index "hours_of_operation", ["service_provider_id"], :name => "service_provider_id"
  add_index "hours_of_operation", ["start_time"], :name => "hoo_start_time"

  create_table "impressions", :force => true do |t|
    t.integer  "client_id"
    t.integer  "client_profile_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.string   "action"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",      :default => 0, :null => false
  end

  add_index "impressions", ["action", "photo_id"], :name => "action"
  add_index "impressions", ["action", "product_type", "product_id"], :name => "action_2"
  add_index "impressions", ["created_at"], :name => "created_at"

  create_table "invitations", :force => true do |t|
    t.integer  "client_id"
    t.string   "email"
    t.datetime "invite_sent"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "reward_amount"
    t.boolean  "already_member", :default => false
  end

  add_index "invitations", ["already_member"], :name => "index_invitations_on_already_member"

  create_table "invoice_item_audit_trails", :force => true do |t|
    t.integer  "invoice_item_id"
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0, :null => false
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.string   "type"
    t.decimal  "price",                    :precision => 8, :scale => 2
    t.string   "coupon_code"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_number"
    t.datetime "certificate_generated_at"
    t.text     "notes"
    t.boolean  "reversed",                                               :default => false
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.integer  "parent_id"
    t.boolean  "is_returnable",                                          :default => true
    t.integer  "item_option_id"
    t.datetime "redeemed_by_client_on"
    t.datetime "redeemed_by_provider_on"
    t.integer  "prepaid_loot_item_id"
    t.decimal  "commission_rate",          :precision => 8, :scale => 4, :default => 0.0
    t.integer  "generated_code_id"
    t.integer  "return_item_id"
    t.integer  "prepaid_loot_units",                                     :default => 1,     :null => false
    t.string   "item_name"
  end

  add_index "invoice_items", ["generated_code_id"], :name => "index_invoice_items_on_generated_code_id"
  add_index "invoice_items", ["invoice_id"], :name => "invoice_id"
  add_index "invoice_items", ["prepaid_loot_item_id", "is_active"], :name => "index_invoice_items_on_prepaid_loot_item_id_and_is_active"
  add_index "invoice_items", ["redeemed_by_client_on"], :name => "index_invoice_items_on_redeemed_by_client_on"
  add_index "invoice_items", ["redeemed_by_provider_on", "redeemed_by_client_on"], :name => "redeemed_index"
  add_index "invoice_items", ["redeemed_by_provider_on"], :name => "index_invoice_items_on_redeemed_by_provider_on"
  add_index "invoice_items", ["return_item_id"], :name => "index_invoice_items_on_return_item_id"
  add_index "invoice_items", ["type", "item_id", "invoice_id"], :name => "type_2"
  add_index "invoice_items", ["type", "item_id", "is_active"], :name => "type"

  create_table "invoices", :force => true do |t|
    t.integer  "billable_id"
    t.string   "billable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referring_source_id"
    t.float    "balance"
    t.string   "type",                :default => "Invoice"
    t.date     "payable_on"
    t.integer  "tracking_source_id"
  end

  add_index "invoices", ["billable_id", "billable_type", "created_at"], :name => "billable_id"
  add_index "invoices", ["billable_type", "billable_id", "id"], :name => "billable_type"
  add_index "invoices", ["billable_type", "billable_id"], :name => "index_invoices_on_billable_type_and_billable_id"
  add_index "invoices", ["created_at", "balance", "id"], :name => "index_invoices_on_created_at_and_balance_and_id"
  add_index "invoices", ["referring_source_id"], :name => "index_invoices_on_referring_source_id"
  add_index "invoices", ["tracking_source_id"], :name => "index_invoices_on_tracking_source_id"

  create_table "lb_ad_regions", :force => true do |t|
    t.string   "name"
    t.integer  "lb_ad_zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_ads", :default => 0
  end

  create_table "lb_ad_regions_lb_ad_units", :id => false, :force => true do |t|
    t.integer "lb_ad_region_id"
    t.integer "lb_ad_unit_id"
  end

  create_table "lb_ad_regions_lb_ads", :id => false, :force => true do |t|
    t.integer "lb_ad_region_id"
    t.integer "lb_ad_id"
  end

  create_table "lb_ad_templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lb_ad_templates_lb_ad_units", :id => false, :force => true do |t|
    t.integer "lb_ad_template_id"
    t.integer "lb_ad_unit_id"
  end

  create_table "lb_ad_units", :force => true do |t|
    t.string   "name"
    t.integer  "height"
    t.integer  "width"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lb_ad_zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lb_ads", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.string   "link"
    t.datetime "live_date"
    t.datetime "exp_date"
    t.integer  "position"
    t.boolean  "rotates"
    t.boolean  "is_active"
    t.integer  "lb_ad_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photo_id"
    t.text     "alt_text"
    t.string   "function"
    t.boolean  "is_function"
  end

  create_table "lb_ads_lb_city_enums", :id => false, :force => true do |t|
    t.integer "lb_ad_id"
    t.integer "lb_city_enum_id"
  end

  create_table "lb_ads_service_categories", :id => false, :force => true do |t|
    t.integer "service_category_id"
    t.integer "lb_ad_id"
  end

  create_table "lb_ads_service_providers", :id => false, :force => true do |t|
    t.integer "service_provider_id"
    t.integer "lb_ad_id"
  end

  create_table "lb_city_enum_meta_service_categories", :force => true do |t|
    t.integer "lb_city_enum_id"
    t.integer "meta_service_category_id"
    t.boolean "in_nav",                           :default => true
    t.boolean "admin_in_nav",                     :default => true
    t.boolean "in_search",                        :default => true
    t.integer "display_order"
    t.boolean "in_provider_setup",                :default => true
    t.boolean "in_client_preferences",            :default => true
    t.integer "client_preferences_display_order"
  end

  create_table "lb_city_enum_service_categories", :force => true do |t|
    t.integer "lb_city_enum_id"
    t.integer "service_category_id"
    t.integer "display_order"
    t.boolean "in_search"
    t.boolean "in_provider_setup"
    t.boolean "in_nav",              :default => true
    t.boolean "admin_in_nav",        :default => true
  end

  create_table "lb_city_enums", :force => true do |t|
    t.string  "name"
    t.string  "short_name"
    t.string  "long_name"
    t.string  "state"
    t.string  "country"
    t.integer "time_zone_enum_id"
    t.boolean "is_active"
    t.integer "zone_id"
    t.integer "invitation_reward_amount", :default => 10
    t.boolean "marketplace_active",       :default => false
    t.boolean "coming_soon",              :default => false
    t.integer "min_num_ratings",          :default => 5
    t.float   "min_rating",               :default => 3.5
    t.string  "time_zone"
  end

  add_index "lb_city_enums", ["is_active", "id"], :name => "is_active"

  create_table "lb_job_applications", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.integer  "lb_job_id"
    t.text     "text_resume"
    t.string   "resume_file_name"
    t.integer  "lb_job_source_id"
    t.string   "lb_source_other"
    t.integer  "lb_job_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lb_job_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  create_table "lb_job_sources", :force => true do |t|
    t.string "name"
  end

  create_table "lb_job_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "lb_jobs", :force => true do |t|
    t.string  "title"
    t.string  "location"
    t.text    "description"
    t.date    "live_date"
    t.integer "lb_job_category_id"
    t.text    "qualifications"
    t.text    "responsibilities"
    t.boolean "published"
  end

  create_table "lb_transactions", :force => true do |t|
    t.decimal  "value",           :precision => 8, :scale => 2
    t.integer  "sp_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cleared_at"
    t.string   "tran_ref_id"
    t.text     "notes"
    t.boolean  "is_active",                                     :default => true
    t.datetime "reversed_at"
    t.integer  "invoice_id"
    t.integer  "pay_with_id"
    t.string   "pay_with_type"
    t.string   "type"
    t.float    "amount_returned",                               :default => 0.0
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.integer  "return_item_id"
  end

  add_index "lb_transactions", ["booking_id"], :name => "index_provider_transactions_on_booking_id"
  add_index "lb_transactions", ["created_at"], :name => "created_at"
  add_index "lb_transactions", ["invoice_id", "tran_ref_id"], :name => "index_lb_transactions_on_invoice_id_and_tran_ref_id"
  add_index "lb_transactions", ["invoice_id"], :name => "invoice_id"
  add_index "lb_transactions", ["return_item_id"], :name => "index_lb_transactions_on_return_item_id"

  create_table "lb_transactions_audit", :primary_key => "audit_id", :force => true do |t|
    t.integer  "id"
    t.decimal  "value",           :precision => 8, :scale => 2
    t.integer  "sp_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cleared_at"
    t.string   "tran_ref_id"
    t.text     "notes"
    t.boolean  "is_active",                                     :default => true
    t.datetime "reversed_at"
    t.integer  "invoice_id"
    t.integer  "pay_with_id"
    t.string   "pay_with_type"
    t.string   "type"
    t.float    "amount_returned",                               :default => 0.0
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.integer  "return_item_id"
  end

  create_table "lifebooked_audits", :force => true do |t|
    t.datetime "prev_start_time"
    t.datetime "new_start_time"
    t.datetime "prev_end_time"
    t.datetime "new_end_time"
    t.integer  "prev_practitioner_id"
    t.integer  "new_practitioner_id"
    t.integer  "service_provider_id"
    t.integer  "booking_id"
    t.boolean  "failed"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",         :default => 0, :null => false
    t.integer  "created_by_id"
    t.string   "created_by_type"
  end

  create_table "loot_audit_trails", :force => true do |t|
    t.integer  "loot_id"
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0, :null => false
  end

  create_table "loot_campaign_banners", :force => true do |t|
    t.integer  "loot_campaign_id"
    t.string   "type"
    t.string   "alt_text"
    t.integer  "photo_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loot_campaign_components", :force => true do |t|
    t.integer  "loot_campaign_id"
    t.string   "constant_contact_identifier"
    t.string   "constant_contact_list_id"
    t.string   "constant_contact_campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 :default => 0, :null => false
  end

  create_table "loot_campaign_loots", :force => true do |t|
    t.integer  "loot_campaign_id"
    t.integer  "loot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",     :default => 0, :null => false
    t.integer  "photo_id"
  end

  add_index "loot_campaign_loots", ["loot_campaign_id", "loot_id"], :name => "loot_campaign_id"

  create_table "loot_campaign_promotions", :force => true do |t|
    t.integer  "loot_campaign_id"
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
  end

  create_table "loot_campaigns", :force => true do |t|
    t.string   "name"
    t.string   "subject_prefix"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",           :default => 0,    :null => false
    t.integer  "top_banner_photo_id"
    t.integer  "bottom_banner_photo_id"
    t.string   "top_banner_link"
    t.string   "bottom_banner_link"
    t.string   "top_banner_alt_text"
    t.string   "bottom_banner_alt_text"
    t.string   "loot_campaign_token"
    t.string   "email_subject"
    t.integer  "lb_city_enum_id"
    t.integer  "blast_id"
    t.string   "color_takeover"
    t.string   "blast_ids"
    t.boolean  "use_ab_testing",         :default => true
    t.integer  "sticker_photo_id"
    t.boolean  "campaign_stickers_off"
    t.boolean  "automated_stickers_off"
  end

  add_index "loot_campaigns", ["bottom_banner_photo_id"], :name => "index_loot_campaigns_on_bottom_banner_photo_id"
  add_index "loot_campaigns", ["loot_campaign_token", "id"], :name => "loot_campaign_token"
  add_index "loot_campaigns", ["loot_campaign_token"], :name => "index_loot_campaigns_on_loot_campaign_token"
  add_index "loot_campaigns", ["top_banner_photo_id"], :name => "index_loot_campaigns_on_top_banner_photo_id"

  create_table "loot_cities", :force => true do |t|
    t.integer  "loot_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "loot_cities", ["city_id", "loot_id"], :name => "index_loot_cities_on_city_id_and_loot_id"
  add_index "loot_cities", ["loot_id", "city_id"], :name => "index_loot_cities_on_loot_id_and_city_id"

  create_table "loot_only_services", :force => true do |t|
    t.string   "name"
    t.integer  "service_category_id"
    t.integer  "service_provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
  end

  create_table "loot_photos", :force => true do |t|
    t.integer  "loot_id"
    t.integer  "photo_id"
    t.boolean  "default_photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0, :null => false
  end

  add_index "loot_photos", ["loot_id", "photo_id"], :name => "index_loot_photos_on_loot_id_and_photo_id"

  create_table "loot_scores", :force => true do |t|
    t.integer  "client_id"
    t.integer  "loot_id"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "loot_scores", ["client_id", "loot_id"], :name => "index_loot_scores_on_client_id_and_loot_id", :unique => true
  add_index "loot_scores", ["loot_id", "client_id"], :name => "index_loot_scores_on_loot_id_and_client_id"

  create_table "loot_service_options", :force => true do |t|
    t.integer "quantity"
    t.integer "quantity_remaining"
    t.string  "name"
    t.integer "loot_service_id"
    t.boolean "is_sold_out"
  end

  create_table "loot_services", :force => true do |t|
    t.float    "original_price"
    t.float    "loot_price"
    t.integer  "starting_quantity"
    t.integer  "quantity_remaining"
    t.integer  "purchase_limit"
    t.boolean  "is_sold_out"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                    :default => 0,     :null => false
    t.datetime "generated_at"
    t.text     "short_description"
    t.string   "name"
    t.integer  "loot_id"
    t.string   "option_type"
    t.integer  "service_category_id"
    t.float    "commission_rate"
    t.integer  "service_id"
    t.boolean  "allow_prepaid_loots",             :default => false
    t.string   "service_type"
    t.integer  "prepaid_loot_units",              :default => 1
    t.boolean  "allow_overselling_prepaid_loots"
  end

  add_index "loot_services", ["loot_id"], :name => "loot_id"
  add_index "loot_services", ["loot_id"], :name => "loot_id_2"
  add_index "loot_services", ["service_id"], :name => "index_loot_services_on_service_provider_service_id"
  add_index "loot_services", ["service_type", "service_id"], :name => "index_loot_services_on_service_type_and_service_id"

  create_table "loot_stock_images", :force => true do |t|
    t.integer  "stock_image_id"
    t.integer  "loot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
  end

  add_index "loot_stock_images", ["stock_image_id", "loot_id"], :name => "index_loot_stock_images_on_stock_image_id_and_loot_id"
  add_index "loot_stock_images", ["stock_image_id", "loot_id"], :name => "stock_image_id_loot_id_index"

  create_table "loots", :force => true do |t|
    t.string   "short_name"
    t.string   "long_name"
    t.string   "business_url"
    t.string   "loot_url_token",                                :null => false
    t.string   "map_image_path"
    t.datetime "live_date"
    t.datetime "end_date"
    t.date     "expiration_date"
    t.text     "what_we_love"
    t.text     "fine_print"
    t.text     "description"
    t.text     "reviews"
    t.text     "how_to_redeem"
    t.integer  "lb_city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "exclusive_text"
    t.integer  "photo_id"
    t.string   "display_url"
    t.string   "provider_email"
    t.string   "address_text"
    t.string   "pdf_address_text"
    t.float    "commission_rate",            :default => 0.0
    t.boolean  "is_published",               :default => true
    t.integer  "waiting_list_id"
    t.integer  "past_deals_order"
    t.integer  "service_provider_id"
    t.boolean  "is_past_deal",               :default => false
    t.text     "email_text"
    t.string   "business_name"
    t.string   "headline"
    t.integer  "gender_id",                  :default => 3
    t.float    "rating",                     :default => 4.0
    t.integer  "email_photo_id"
    t.string   "email_subject"
    t.string   "email_title"
    t.string   "email_subtitle"
    t.integer  "admin_user_id"
    t.float    "partial_payment_percent",    :default => 0.0
    t.date     "partial_payment_date"
    t.boolean  "is_valid_on_date"
    t.datetime "locked_until"
    t.integer  "locked_by_id"
    t.string   "locked_by_type"
    t.boolean  "show_only_on_campaign_page", :default => false
    t.integer  "zone_override_id"
  end

  add_index "loots", ["lb_city_id", "is_published", "live_date", "end_date", "id"], :name => "lb_city_id_2"
  add_index "loots", ["lb_city_id", "is_published", "live_date", "end_date"], :name => "lb_city_id"
  add_index "loots", ["loot_url_token"], :name => "index_loots_on_loot_url_token", :unique => true
  add_index "loots", ["service_provider_id"], :name => "service_provider_id"

  create_table "marketing_photos", :force => true do |t|
    t.string   "name"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  create_table "message_tasks", :force => true do |t|
    t.string   "task_class"
    t.string   "task_method"
    t.binary   "task_object"
    t.boolean  "is_new",      :default => true
    t.datetime "created_at"
    t.integer  "group_id"
    t.string   "worker_id"
  end

  create_table "meta_service_categories", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "show_in_client_preferences",       :default => false
    t.integer  "client_preferences_display_order"
    t.string   "client_preferences_display_name"
  end

  add_index "meta_service_categories", ["name"], :name => "name"

  create_table "meta_service_categories_search_tab_types", :id => false, :force => true do |t|
    t.integer "meta_service_category_id"
    t.integer "search_tab_type_id"
  end

  create_table "meta_service_categories_service_categories", :id => false, :force => true do |t|
    t.integer "meta_service_category_id"
    t.integer "service_category_id"
  end

  add_index "meta_service_categories_service_categories", ["meta_service_category_id", "service_category_id"], :name => "meta_service_category_id"

  create_table "mobile_carriers", :force => true do |t|
    t.string   "mobile_carrier_name", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gateway",             :limit => 50
  end

  create_table "nearby_zone_records", :force => true do |t|
    t.integer  "zone_id"
    t.integer  "nearby_zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
  end

  add_index "nearby_zone_records", ["zone_id", "nearby_zone_id"], :name => "index_nearby_zone_records_on_zone_id_and_nearby_zone_id"

  create_table "old_booking_state_changes", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "from_state"
    t.integer  "to_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "old_booking_state_changes", ["booking_id"], :name => "index_booking_state_changes_on_booking_id"
  add_index "old_booking_state_changes", ["updated_at", "created_at", "booking_id"], :name => "updated_at"

  create_table "old_bookings", :force => true do |t|
    t.integer  "client_id"
    t.integer  "service_provider_resource_id"
    t.integer  "service_provider_service_id"
    t.datetime "appt_time"
    t.integer  "duration"
    t.integer  "price"
    t.integer  "state_id"
    t.boolean  "notify_via_sms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sp_id"
    t.boolean  "is_active"
    t.float    "service_charge"
    t.boolean  "is_charge_sp"
    t.float    "rating"
    t.text     "rating_blurb"
    t.datetime "last_alert"
    t.integer  "reason_id"
    t.text     "reason_blurb"
    t.integer  "unavailability_id"
    t.integer  "lock_version",                                           :default => 0
    t.string   "rating_title",                            :limit => 100
    t.integer  "customer_provider_history_type_id"
    t.datetime "booked_at"
    t.float    "discount_amt"
    t.integer  "asset_block_id"
    t.integer  "locked_gender"
    t.integer  "locked_practitioner"
    t.string   "client_notes",                            :limit => 200
    t.integer  "cartable_sp_service_id"
    t.integer  "referring_source_id"
    t.datetime "last_alert_support"
    t.integer  "last_alert_sp_count",                                    :default => 0
    t.float    "no_show_charge_amount",                                  :default => 0.0
    t.float    "late_cancellation_charge_amount",                        :default => 0.0
    t.integer  "cancellation_period"
    t.float    "late_cancellation_service_charge_amount",                :default => 0.0
    t.float    "no_show_service_charge_amount",                          :default => 0.0
    t.string   "referring_source_sub_id"
    t.float    "selected_price"
    t.integer  "cart_item_id"
    t.float    "price_to_charge"
    t.integer  "last_phone_alert_sp_count",                              :default => 0
    t.text     "client_dispute_notes"
    t.integer  "break_asset_block_id"
    t.string   "remote_booking_id"
    t.integer  "tracking_source_id"
    t.string   "state"
    t.datetime "last_transition_time"
    t.integer  "city_id"
    t.integer  "potential_rewards"
    t.boolean  "sent_rating_reminder",                                   :default => false
    t.boolean  "sent_customer_reminder",                                 :default => false
  end

  add_index "old_bookings", ["appt_time"], :name => "index_bookings_on_appt_time"
  add_index "old_bookings", ["asset_block_id"], :name => "asset_block_id"
  add_index "old_bookings", ["booked_at"], :name => "index_bookings_on_booked_at"
  add_index "old_bookings", ["cart_item_id"], :name => "index_bookings_on_cart_item_id"
  add_index "old_bookings", ["cartable_sp_service_id"], :name => "cartable_sp_service_id"
  add_index "old_bookings", ["client_id", "state_id"], :name => "client_id"
  add_index "old_bookings", ["client_id"], :name => "index_bookings_on_client_id"
  add_index "old_bookings", ["rating"], :name => "index_bookings_on_rating"
  add_index "old_bookings", ["remote_booking_id"], :name => "index_bookings_on_remote_booking_id"
  add_index "old_bookings", ["service_provider_service_id", "sp_id", "created_at"], :name => "service_provider_service_id"
  add_index "old_bookings", ["service_provider_service_id"], :name => "index_bookings_on_service_provider_service_id"
  add_index "old_bookings", ["sp_id"], :name => "sp_id"
  add_index "old_bookings", ["state", "appt_time"], :name => "index_bookings_on_state_and_appt_time"
  add_index "old_bookings", ["state", "client_id"], :name => "index_bookings_on_state_and_client_id"
  add_index "old_bookings", ["state_id", "appt_time"], :name => "state_id"
  add_index "old_bookings", ["tracking_source_id"], :name => "index_bookings_on_tracking_source_id"

  create_table "old_client_reviews", :force => true do |t|
    t.integer  "review_source_id"
    t.text     "client_name"
    t.text     "body"
    t.integer  "helpfulness",         :default => 0
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_featured",         :default => false
    t.boolean  "is_pending_featured", :default => true
    t.string   "review_source_type"
    t.string   "reviewed_type"
    t.integer  "reviewed_id"
    t.integer  "service_provider_id"
    t.integer  "client_id"
    t.float    "rating"
  end

  add_index "old_client_reviews", ["client_id"], :name => "index_client_reviews_on_client_id"
  add_index "old_client_reviews", ["is_active", "is_featured"], :name => "index_client_reviews_active_featured"
  add_index "old_client_reviews", ["is_active", "reviewed_type", "reviewed_id"], :name => "is_active"
  add_index "old_client_reviews", ["is_active"], :name => "index_client_reviews_on_is_active"
  add_index "old_client_reviews", ["rating"], :name => "index_client_reviews_on_rating"
  add_index "old_client_reviews", ["review_source_id"], :name => "booking_id"
  add_index "old_client_reviews", ["review_source_type", "review_source_id"], :name => "index_client_reviews_on_review_source_type_and_review_source_id", :unique => true
  add_index "old_client_reviews", ["reviewed_type", "reviewed_id"], :name => "index_client_reviews_on_reviewed_type_and_reviewed_id"
  add_index "old_client_reviews", ["service_provider_id", "is_active", "reviewed_type", "reviewed_id"], :name => "service_provider_id"
  add_index "old_client_reviews", ["service_provider_id", "is_active", "reviewed_type", "reviewed_id"], :name => "service_provider_id_2"
  add_index "old_client_reviews", ["service_provider_id"], :name => "index_client_reviews_on_service_provider_id"

  create_table "old_invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.string   "type"
    t.decimal  "price",                    :precision => 8, :scale => 2
    t.string   "coupon_code"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_number"
    t.datetime "certificate_generated_at"
    t.text     "notes"
    t.boolean  "reversed",                                               :default => false
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.integer  "parent_id"
    t.boolean  "is_returnable",                                          :default => true
    t.integer  "item_option_id"
    t.datetime "redeemed_by_client_on"
    t.datetime "redeemed_by_provider_on"
    t.integer  "prepaid_loot_item_id"
    t.decimal  "commission_rate",          :precision => 8, :scale => 4, :default => 0.0
    t.integer  "generated_code_id"
    t.integer  "return_item_id"
    t.integer  "prepaid_loot_units",                                     :default => 1,     :null => false
  end

  add_index "old_invoice_items", ["generated_code_id"], :name => "index_invoice_items_on_generated_code_id"
  add_index "old_invoice_items", ["invoice_id"], :name => "invoice_id"
  add_index "old_invoice_items", ["prepaid_loot_item_id", "is_active"], :name => "index_invoice_items_on_prepaid_loot_item_id_and_is_active"
  add_index "old_invoice_items", ["redeemed_by_client_on"], :name => "index_invoice_items_on_redeemed_by_client_on"
  add_index "old_invoice_items", ["redeemed_by_provider_on", "redeemed_by_client_on"], :name => "redeemed_index"
  add_index "old_invoice_items", ["redeemed_by_provider_on"], :name => "index_invoice_items_on_redeemed_by_provider_on"
  add_index "old_invoice_items", ["return_item_id"], :name => "index_invoice_items_on_return_item_id"
  add_index "old_invoice_items", ["type", "item_id", "invoice_id"], :name => "type_2"
  add_index "old_invoice_items", ["type", "item_id", "is_active"], :name => "type"

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active",  :default => true
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "short_name"
    t.string   "long_name"
  end

  create_table "penguin_eggs", :force => true do |t|
    t.string   "name"
    t.string   "puffin_type"
    t.string   "queue"
    t.string   "meta_data"
    t.string   "load_using"
    t.binary   "handler"
    t.binary   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.datetime "start"
    t.datetime "finished_at"
    t.integer  "priority"
    t.integer  "locked_by"
    t.integer  "attempts"
    t.integer  "job_id"
    t.integer  "time_taken"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "penguin_eggs", ["queue"], :name => "index_penguin_eggs_on_queue"

  create_table "penguin_puffins", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.boolean  "available"
    t.integer  "assigned_to"
    t.integer  "processing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string "name"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "permissions_roles", ["permission_id", "role_id"], :name => "index_permissions_roles_on_permission_id_and_role_id"
  add_index "permissions_roles", ["role_id", "permission_id"], :name => "index_permissions_roles_on_role_id_and_permission_id"

  create_table "photo_galleries", :force => true do |t|
    t.integer  "default_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_gallery_photos", :force => true do |t|
    t.integer  "photo_gallery_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photo_gallery_photos", ["photo_gallery_id", "photo_id"], :name => "photo_gallery_id"

  create_table "photos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_file_name"
    t.string   "signature"
  end

  add_index "photos", ["id"], :name => "id"

  create_table "postal_codes", :force => true do |t|
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "zone_id"
  end

  create_table "prepaid_loot_items", :force => true do |t|
    t.integer  "category_id"
    t.integer  "service_id"
    t.integer  "prepaid_loot_id"
    t.string   "service_type"
    t.decimal  "dollar_value",               :precision => 10, :scale => 2
    t.integer  "units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                              :default => 0,   :null => false
    t.datetime "closed_out_at"
    t.integer  "items_remaining_cache"
    t.integer  "units_per_item",                                            :default => 1
    t.decimal  "cost_per_unit",              :precision => 10, :scale => 2, :default => 0.0
    t.integer  "units_remaining_cache"
    t.decimal  "dollar_amount_charged_back", :precision => 10, :scale => 2, :default => 0.0
  end

  add_index "prepaid_loot_items", ["closed_out_at"], :name => "index_prepaid_loot_items_on_closed_out_at"
  add_index "prepaid_loot_items", ["prepaid_loot_id"], :name => "index_prepaid_loot_items_on_prepaid_loot_id"

  create_table "prepaid_loots", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "provider_id"
    t.integer  "prepaid_loot_invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",            :default => 0, :null => false
  end

  add_index "prepaid_loots", ["prepaid_loot_invoice_id"], :name => "index_prepaid_loots_on_prepaid_loot_invoice_id"
  add_index "prepaid_loots", ["provider_id", "start_date", "end_date"], :name => "index_prepaid_loots_on_provider_id_and_start_date_and_end_date"

  create_table "price_ranges", :force => true do |t|
    t.integer  "range_start"
    t.integer  "range_end"
    t.float    "newnew"
    t.float    "oldnew"
    t.float    "oldold"
    t.text     "description"
    t.boolean  "is_default",            :default => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "price_schedule_id"
    t.float    "service_charge_newnew", :default => 0.1
    t.float    "service_charge_oldnew", :default => 0.05
    t.float    "service_charge_oldold", :default => 0.05
  end

  create_table "price_schedules", :force => true do |t|
    t.text     "description"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "private_notes", :force => true do |t|
    t.boolean "is_active"
  end

  create_table "product_giveaways", :force => true do |t|
    t.string   "title"
    t.binary   "image_file_data"
    t.text     "description"
    t.string   "link"
    t.boolean  "is_active",       :default => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "product_views", :force => true do |t|
    t.integer  "client_id"
    t.integer  "client_profile_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
    t.integer  "service_category_id"
  end

  add_index "product_views", ["client_id", "product_type", "product_id"], :name => "index_product_views_on_client_id_and_product_type_and_product_id"
  add_index "product_views", ["client_id", "service_category_id"], :name => "client_id_sc_id"
  add_index "product_views", ["client_profile_id", "product_type", "product_id"], :name => "client_profile_id_product"
  add_index "product_views", ["product_type", "product_id"], :name => "index_product_views_on_product_type_and_product_id"

  create_table "promotion_categories", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "service_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
  end

  create_table "promotion_services", :force => true do |t|
    t.integer  "service_provider_service_id"
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                :default => 0, :null => false
  end

  create_table "promotion_stock_images", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "stock_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
  end

  add_index "promotion_stock_images", ["promotion_id", "stock_image_id"], :name => "index_promotion_stock_images_on_promotion_id_and_stock_image_id"
  add_index "promotion_stock_images", ["stock_image_id", "promotion_id"], :name => "stock_image_id_promotion_id_index"

  create_table "promotion_types", :force => true do |t|
    t.string "name"
    t.string "promotion_class_name"
  end

  create_table "promotions", :force => true do |t|
    t.string   "type"
    t.string   "long_name"
    t.string   "short_name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "service_provider_id"
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "email_photo_id"
    t.integer  "ad_photo_id"
    t.integer  "lb_city_enum_id"
    t.integer  "position"
    t.boolean  "is_active",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",          :default => 0,     :null => false
    t.string   "email_subject"
    t.string   "email_title"
    t.string   "email_subtitle"
    t.string   "business_display_name"
    t.float    "rating"
    t.integer  "gender_id"
  end

  add_index "promotions", ["service_provider_id", "start_date", "end_date", "is_active"], :name => "service_provider_id_3"
  add_index "promotions", ["service_provider_id", "start_date", "end_date"], :name => "service_provider_id_2"
  add_index "promotions", ["service_provider_id"], :name => "service_provider_id"
  add_index "promotions", ["start_date", "end_date"], :name => "start_date"

  create_table "provider_messages", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "title"
    t.text     "message"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  create_table "provider_promo_code_uses", :force => true do |t|
    t.integer  "service_provider_id"
    t.integer  "provider_promo_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",           :default => 0, :null => false
  end

  create_table "provider_promo_codes", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "max_uses"
    t.integer  "max_uses_per_provider"
    t.datetime "expires_at"
    t.float    "value"
    t.integer  "provider_promo_code_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                :default => 0, :null => false
  end

  create_table "provider_setups", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "step",                :limit => 50, :default => "0"
    t.integer  "service_provider_id"
    t.string   "highest_step",        :limit => 50, :default => "0"
    t.integer  "photo_id"
    t.integer  "photo_gallery_id"
  end

  create_table "provider_stock_images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
    t.integer  "stock_image_id"
    t.integer  "city_id"
    t.integer  "provider_id"
  end

  add_index "provider_stock_images", ["city_id", "stock_image_id", "provider_id"], :name => "provider_stock_image_index"

  create_table "provider_tasks", :force => true do |t|
    t.string   "task_method"
    t.binary   "task_object",    :limit => 2147483647
    t.boolean  "is_new",                               :default => true
    t.integer  "group_id"
    t.string   "worker_id"
    t.datetime "created_at"
    t.binary   "task_arguments", :limit => 2147483647
    t.text     "description"
  end

  create_table "provider_versions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",          :default => 0,     :null => false
    t.integer  "provider_id"
    t.boolean  "is_approved",           :default => false
    t.text     "statement_of_business"
    t.text     "cancellation_policy"
  end

  add_index "provider_versions", ["provider_id", "is_approved"], :name => "index_provider_versions_on_provider_id_and_is_approved"

  create_table "queries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reasons", :force => true do |t|
    t.string   "reason"
    t.string   "reason_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redeemed_invitations", :force => true do |t|
    t.integer  "inviter_client_id"
    t.integer  "invitee_client_id"
    t.integer  "redeemed_via_id"
    t.integer  "invitation_id"
    t.datetime "redeemed_date"
    t.datetime "rewarded_date"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "redeemed_via_type"
    t.boolean  "is_scammer"
  end

  create_table "referring_sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gross_commission_rate", :default => 0
    t.integer  "net_commission_rate",   :default => 0
    t.string   "email"
    t.string   "api_key"
  end

  add_index "referring_sources", ["api_key"], :name => "index_referring_sources_on_api_key"
  add_index "referring_sources", ["name"], :name => "name"

  create_table "relationships", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "relationships_reward_code_rules", :id => false, :force => true do |t|
    t.integer "relationship_id"
    t.integer "reward_code_rule_id"
  end

  create_table "return_items", :force => true do |t|
    t.string   "reason"
    t.integer  "returned_by_id"
    t.string   "returned_by_type"
    t.date     "check_requested_at"
    t.date     "check_received_at"
    t.string   "return_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "custom_reason"
  end

  add_index "return_items", ["type"], :name => "index_return_items_on_type"

  create_table "review_responses", :force => true do |t|
    t.text     "responder_name"
    t.text     "body"
    t.boolean  "is_active"
    t.integer  "client_review_id"
    t.integer  "respondable_id"
    t.string   "respondable_type"
    t.text     "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_code_rules", :force => true do |t|
    t.integer "reward_code_id"
    t.integer "service_provider_id"
    t.boolean "allow_discounted"
    t.boolean "allow_add_remainder_dollars"
    t.integer "minimum_booking_price_after_discount"
    t.boolean "is_paid_by_sp",                        :default => false
  end

  create_table "reward_code_rules_service_provider_service_categories", :id => false, :force => true do |t|
    t.integer "reward_code_rule_id"
    t.integer "service_provider_service_category_id"
  end

  create_table "reward_code_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "reward_codes", :force => true do |t|
    t.string   "name"
    t.integer  "reward_code_type_id",   :default => 1
    t.integer  "reward_policy_type_id", :default => 3
    t.date     "effective_date"
    t.date     "expiration_date"
    t.float    "value"
    t.integer  "max_allowed_uses",      :default => 1
    t.integer  "max_uses_per_customer", :default => 1
    t.text     "notes"
    t.boolean  "is_active",             :default => true
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "current_uses",          :default => 0
    t.boolean  "first_time_only"
    t.boolean  "auto_generated_code",   :default => false
  end

  add_index "reward_codes", ["auto_generated_code"], :name => "index_reward_codes_on_auto_generated_code"
  add_index "reward_codes", ["reward_code_type_id"], :name => "index_reward_codes_on_reward_code_type_id"
  add_index "reward_codes", ["reward_policy_type_id"], :name => "index_reward_codes_on_reward_policy_type_id"

  create_table "reward_dollars", :force => true do |t|
    t.float    "amount"
    t.integer  "client_id"
    t.integer  "created_by_id"
    t.string   "created_by_type"
    t.boolean  "active",          :default => true
    t.boolean  "spent",           :default => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0,     :null => false
    t.string   "type"
    t.date     "expiration_date"
  end

  add_index "reward_dollars", ["client_id", "expiration_date"], :name => "index_reward_dollars_on_client_id_and_expiration_date"
  add_index "reward_dollars", ["created_by_type", "created_by_id"], :name => "created_by_type"

  create_table "reward_policy_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
    t.text     "description"
  end

  create_table "rolling_discounts", :force => true do |t|
    t.float    "amount"
    t.integer  "number_of_days"
    t.integer  "provider_id"
    t.datetime "last_run"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rolling_discounts", ["provider_id"], :name => "index_rolling_discounts_on_provider_id"

  create_table "rude_queues", :force => true do |t|
    t.string   "queue_name"
    t.text     "data"
    t.boolean  "processed",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0,     :null => false
  end

  add_index "rude_queues", ["processed"], :name => "index_rude_queues_on_processed"
  add_index "rude_queues", ["queue_name", "processed"], :name => "index_rude_queues_on_queue_name_and_processed"

  create_table "salutations", :force => true do |t|
    t.string   "salutation_name", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_tab_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.integer  "display_order", :default => 1
    t.boolean  "is_active",     :default => true
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "search_terms", :force => true do |t|
    t.string  "term"
    t.integer "count"
    t.integer "weight"
    t.boolean "disabled"
  end

  add_index "search_terms", ["term"], :name => "index_search_terms_on_term"

  create_table "service_availabilities", :force => true do |t|
    t.integer  "service_provider_service_id"
    t.integer  "discount_id"
    t.integer  "service_provider_id"
    t.integer  "asset_id"
    t.integer  "gender_id"
    t.integer  "service_category_id"
    t.integer  "counter_cache",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_availabilities", ["discount_id"], :name => "discount_id"
  add_index "service_availabilities", ["service_category_id"], :name => "sa_sc_id"
  add_index "service_availabilities", ["service_provider_id"], :name => "sa_sp_id"
  add_index "service_availabilities", ["service_provider_service_id"], :name => "sa_svc_id"

  create_table "service_categories", :force => true do |t|
    t.string   "display_name",                  :limit => 60
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "home_meta_service_category_id"
    t.string   "name",                          :limit => 15
    t.integer  "rebooking_photo_id"
    t.string   "rebooking_headline"
    t.text     "rebooking_copy"
    t.integer  "rebooking_interval"
    t.string   "gender",                                      :default => "unisex"
  end

  create_table "service_category_marketing_photos", :force => true do |t|
    t.integer  "service_category_id"
    t.integer  "marketing_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",        :default => 0, :null => false
  end

  create_table "service_category_price_schedules", :force => true do |t|
    t.integer  "service_category_id"
    t.integer  "price_schedule_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "service_provider_holidays", :force => true do |t|
    t.integer  "service_provider_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",           :default => 0, :null => false
    t.integer  "holiday_asset_block_id"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "service_provider_payment_types", :force => true do |t|
    t.integer "service_provider_id"
    t.integer "payment_type_id"
  end

  add_index "service_provider_payment_types", ["payment_type_id", "service_provider_id"], :name => "payment_type_id"

  create_table "service_provider_resource_recurring_availabilities", :force => true do |t|
    t.integer  "service_provider_resource_id"
    t.integer  "day_of_week_id"
    t.integer  "start_time"
    t.integer  "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "block_type",                   :default => 0
    t.integer  "frequency",                    :default => 0
    t.datetime "recurring_end_date"
    t.boolean  "is_recurring_indefinitely"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.text     "provider_note"
    t.text     "extra_data"
  end

  add_index "service_provider_resource_recurring_availabilities", ["day_of_week_id"], :name => "sprra_dow_id"
  add_index "service_provider_resource_recurring_availabilities", ["end_time"], :name => "sprra_end_time"
  add_index "service_provider_resource_recurring_availabilities", ["start_time"], :name => "sprra_start_time"

  create_table "service_provider_resource_services", :force => true do |t|
    t.integer  "service_provider_resource_id"
    t.integer  "service_provider_service_id"
    t.datetime "active_from"
    t.datetime "active_until"
    t.integer  "is_active",                    :default => 1
  end

  add_index "service_provider_resource_services", ["is_active", "service_provider_resource_id", "service_provider_service_id"], :name => "is_active"
  add_index "service_provider_resource_services", ["service_provider_resource_id", "service_provider_service_id", "is_active"], :name => "service_provider_resource_id"
  add_index "service_provider_resource_services", ["service_provider_resource_id"], :name => "sprs_spr_id"
  add_index "service_provider_resource_services", ["service_provider_service_id"], :name => "sprs_sps_id"

  create_table "service_provider_resource_unavailabilities", :force => true do |t|
    t.integer  "service_provider_resource_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "unavailability_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_frozen"
    t.integer  "spaces_left"
    t.integer  "lock_version",                 :default => 0
    t.integer  "block_type",                   :default => 0
    t.text     "provider_note"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
  end

  add_index "service_provider_resource_unavailabilities", ["service_provider_resource_id", "start_time", "end_time"], :name => "service_provider_resource_unavailabilities_unique_index"

  create_table "service_provider_resources", :force => true do |t|
    t.integer  "service_provider_id"
    t.string   "name",                   :limit => 40
    t.string   "gender",                 :limit => 1
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "capacity",                             :default => 1
    t.integer  "is_active",                            :default => 1
    t.string   "last_name",              :limit => 1
    t.integer  "linked_service_id"
    t.integer  "asset_type",                           :default => 0
    t.string   "remote_practitioner_id"
  end

  create_table "service_provider_service_categories", :force => true do |t|
    t.integer  "service_provider_id"
    t.integer  "service_category_id"
    t.integer  "is_active",           :default => 1
    t.float    "avg_rating"
    t.integer  "schedule_id"
    t.integer  "num_ratings"
    t.boolean  "is_approved",         :default => false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "num_searches",        :default => 0
    t.float    "ranking_value",       :default => 0.0
    t.integer  "lock_version",        :default => 0
    t.integer  "recent_bookings",     :default => 0
  end

  add_index "service_provider_service_categories", ["is_active"], :name => "is_active"
  add_index "service_provider_service_categories", ["recent_bookings"], :name => "index_service_provider_service_categories_on_recent_bookings"
  add_index "service_provider_service_categories", ["service_category_id"], :name => "spsc_sc_id"
  add_index "service_provider_service_categories", ["service_provider_id"], :name => "spsc_sp_id"

  create_table "service_provider_service_category_price_schedules", :force => true do |t|
    t.integer  "service_provider_service_category_id"
    t.integer  "service_category_price_schedule_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "service_provider_services", :force => true do |t|
    t.integer  "service_provider_id"
    t.integer  "service_category_id"
    t.string   "name",                                 :limit => 100
    t.integer  "duration"
    t.float    "reg_price"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.text     "description"
    t.boolean  "is_active",                                           :default => true
    t.integer  "service_provider_service_category_id"
    t.integer  "gender"
    t.integer  "asset_type"
    t.integer  "num_searches",                                        :default => 0
    t.float    "ranking_value",                                       :default => 0.0
    t.integer  "recent_bookings",                                     :default => 0
    t.float    "avg_rating"
    t.integer  "num_ratings",                                         :default => 0
    t.boolean  "is_frozen",                                           :default => true
    t.boolean  "is_approved"
    t.integer  "version"
    t.integer  "num_practitioners",                                   :default => 1
    t.integer  "latest_approved_version_id"
    t.integer  "break_time",                                          :default => 0
    t.string   "remote_service_id"
    t.string   "category_web_service_id"
    t.boolean  "is_deleted",                                          :default => false
  end

  add_index "service_provider_services", ["id", "is_active"], :name => "id"
  add_index "service_provider_services", ["is_active"], :name => "is_active"
  add_index "service_provider_services", ["is_approved", "is_frozen"], :name => "index_service_provider_services_on_is_approved_and_is_frozen"
  add_index "service_provider_services", ["is_deleted"], :name => "index_service_provider_services_on_is_deleted"
  add_index "service_provider_services", ["service_provider_id"], :name => "service_provider_id"
  add_index "service_provider_services", ["service_provider_service_category_id"], :name => "service_provider_service_spsc_id"

  create_table "service_provider_signup_steps", :id => false, :force => true do |t|
    t.integer "service_provider_id"
    t.integer "signup_step_id"
  end

  create_table "service_providers", :force => true do |t|
    t.string   "email",                           :limit => 60
    t.string   "old_crypted_password",            :limit => 40
    t.string   "old_salt",                        :limit => 40
    t.string   "activation_code",                 :limit => 40
    t.datetime "activated_at"
    t.string   "name",                            :limit => 200
    t.string   "first_name",                      :limit => 100
    t.string   "last_name",                       :limit => 100
    t.string   "phone",                           :limit => 15
    t.string   "fax",                             :limit => 15
    t.string   "mobile_number",                   :limit => 15
    t.integer  "mobile_carrier_id"
    t.integer  "company_address_id"
    t.string   "url",                             :limit => 100
    t.text     "statement_of_business"
    t.integer  "number_of_employees"
    t.boolean  "on_trial"
    t.integer  "remaining_trial_appointments"
    t.string   "billing_name",                    :limit => 100
    t.string   "billing_email",                   :limit => 100
    t.integer  "billing_address_id"
    t.boolean  "confirm_legal_flag"
    t.date     "canceled_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "accept_phone_alert",                             :default => true
    t.boolean  "accept_fax_alert",                               :default => true
    t.boolean  "accept_email_alert",                             :default => true
    t.boolean  "accept_sms_alert",                               :default => false
    t.integer  "credit_card_id"
    t.text     "cancellation_policy"
    t.string   "login_token",                     :limit => 40
    t.integer  "cancellation_period",                            :default => 0
    t.float    "avg_rating"
    t.integer  "zone_id"
    t.integer  "num_ratings"
    t.float    "deposit_amount_required"
    t.boolean  "cc_required",                                    :default => true
    t.string   "old_user_name",                   :limit => 60
    t.string   "ivr_phone",                       :limit => 15
    t.integer  "contact_type",                                   :default => 0
    t.text     "alert_email"
    t.integer  "user_type",                                      :default => 1
    t.integer  "staff_type_id"
    t.text     "editorial_review"
    t.string   "name_for_url"
    t.boolean  "can_have_homepage",                              :default => false
    t.integer  "photo_id"
    t.integer  "lb_city_enum_id"
    t.integer  "photo_gallery_id"
    t.integer  "highest_setup_step_completed"
    t.boolean  "completed_setup",                                :default => false
    t.boolean  "is_frozen",                                      :default => true,  :null => false
    t.boolean  "is_approved",                                    :default => false, :null => false
    t.integer  "version"
    t.float    "appointment_credits",                            :default => 0.0
    t.integer  "highest_tutorial_step_completed",                :default => 0
    t.integer  "braintree_customer_id"
    t.boolean  "is_loot_only_account",                           :default => false
    t.string   "checks_payable_to"
    t.integer  "payment_address_id"
    t.float    "service_charge_rate",                            :default => 0.2
    t.float    "free_service_charge",                            :default => 20.0
    t.boolean  "is_loot_provider",                               :default => false
    t.float    "service_charge_minimum"
    t.integer  "latest_approved_version_id"
    t.integer  "default_loot_payment_percentage",                :default => 80
    t.text     "encrypted_bank_account_number"
    t.string   "routing_number"
    t.string   "bank_account_type"
    t.integer  "minimum_booking_time_buffer",                    :default => 60
    t.boolean  "editors_pick",                                   :default => false, :null => false
    t.boolean  "is_deleted",                                     :default => false
    t.boolean  "auto_charge_enabled",                            :default => true
    t.string   "time_zone"
  end

  add_index "service_providers", ["activated_at", "canceled_at"], :name => "index_service_providers_on_activated_at_and_canceled_at"
  add_index "service_providers", ["is_approved", "created_at"], :name => "is_approved"
  add_index "service_providers", ["is_approved", "is_frozen"], :name => "index_service_providers_on_is_approved_and_is_frozen"
  add_index "service_providers", ["is_deleted", "activated_at", "name"], :name => "index_service_providers_on_is_deleted_and_activated_at_and_name"
  add_index "service_providers", ["is_loot_only_account", "completed_setup", "id"], :name => "is_loot_only_account"
  add_index "service_providers", ["lb_city_enum_id", "zone_id", "company_address_id", "photo_gallery_id", "id"], :name => "lb_city_enum_id"
  add_index "service_providers", ["old_user_name"], :name => "user_name"
  add_index "service_providers", ["zone_id"], :name => "sp_zone_id"

  create_table "service_versions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0,     :null => false
    t.integer  "service_id"
    t.boolean  "is_approved",  :default => false
    t.string   "name"
    t.text     "description"
    t.float    "reg_price"
    t.boolean  "is_active",    :default => true
    t.boolean  "is_deleted",   :default => false
  end

  add_index "service_versions", ["service_id", "is_approved"], :name => "index_service_versions_on_service_id_and_is_approved"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.datetime "updated_at"
    t.text     "data",       :limit => 2147483647
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "signup_steps", :force => true do |t|
    t.string   "text_name",  :limit => 50
    t.integer  "depth",                    :default => 0
    t.integer  "number"
    t.integer  "position",                 :default => 0
    t.integer  "parent_id",                :default => 0
    t.string   "controller", :limit => 40
    t.string   "action",     :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_active",                :default => 1
  end

  create_table "site_pages", :force => true do |t|
    t.text     "url"
    t.text     "title"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_pages", ["url"], :name => "url", :length => {"url"=>100}

  create_table "sites", :force => true do |t|
    t.string   "name",        :limit => 40
    t.string   "domain",      :limit => 100
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slot_set_counters", :id => false, :force => true do |t|
    t.integer "counter", :default => 1
  end

  create_table "slot_set_records", :force => true do |t|
    t.integer  "service_availability_id"
    t.integer  "day_of_week_id"
    t.boolean  "s0",                      :default => false
    t.boolean  "s15",                     :default => false
    t.boolean  "s30",                     :default => false
    t.boolean  "s45",                     :default => false
    t.boolean  "s100",                    :default => false
    t.boolean  "s115",                    :default => false
    t.boolean  "s130",                    :default => false
    t.boolean  "s145",                    :default => false
    t.boolean  "s200",                    :default => false
    t.boolean  "s215",                    :default => false
    t.boolean  "s230",                    :default => false
    t.boolean  "s245",                    :default => false
    t.boolean  "s300",                    :default => false
    t.boolean  "s315",                    :default => false
    t.boolean  "s330",                    :default => false
    t.boolean  "s345",                    :default => false
    t.boolean  "s400",                    :default => false
    t.boolean  "s415",                    :default => false
    t.boolean  "s430",                    :default => false
    t.boolean  "s445",                    :default => false
    t.boolean  "s500",                    :default => false
    t.boolean  "s515",                    :default => false
    t.boolean  "s530",                    :default => false
    t.boolean  "s545",                    :default => false
    t.boolean  "s600",                    :default => false
    t.boolean  "s615",                    :default => false
    t.boolean  "s630",                    :default => false
    t.boolean  "s645",                    :default => false
    t.boolean  "s700",                    :default => false
    t.boolean  "s715",                    :default => false
    t.boolean  "s730",                    :default => false
    t.boolean  "s745",                    :default => false
    t.boolean  "s800",                    :default => false
    t.boolean  "s815",                    :default => false
    t.boolean  "s830",                    :default => false
    t.boolean  "s845",                    :default => false
    t.boolean  "s900",                    :default => false
    t.boolean  "s915",                    :default => false
    t.boolean  "s930",                    :default => false
    t.boolean  "s945",                    :default => false
    t.boolean  "s1000",                   :default => false
    t.boolean  "s1015",                   :default => false
    t.boolean  "s1030",                   :default => false
    t.boolean  "s1045",                   :default => false
    t.boolean  "s1100",                   :default => false
    t.boolean  "s1115",                   :default => false
    t.boolean  "s1130",                   :default => false
    t.boolean  "s1145",                   :default => false
    t.boolean  "s1200",                   :default => false
    t.boolean  "s1215",                   :default => false
    t.boolean  "s1230",                   :default => false
    t.boolean  "s1245",                   :default => false
    t.boolean  "s1300",                   :default => false
    t.boolean  "s1315",                   :default => false
    t.boolean  "s1330",                   :default => false
    t.boolean  "s1345",                   :default => false
    t.boolean  "s1400",                   :default => false
    t.boolean  "s1415",                   :default => false
    t.boolean  "s1430",                   :default => false
    t.boolean  "s1445",                   :default => false
    t.boolean  "s1500",                   :default => false
    t.boolean  "s1515",                   :default => false
    t.boolean  "s1530",                   :default => false
    t.boolean  "s1545",                   :default => false
    t.boolean  "s1600",                   :default => false
    t.boolean  "s1615",                   :default => false
    t.boolean  "s1630",                   :default => false
    t.boolean  "s1645",                   :default => false
    t.boolean  "s1700",                   :default => false
    t.boolean  "s1715",                   :default => false
    t.boolean  "s1730",                   :default => false
    t.boolean  "s1745",                   :default => false
    t.boolean  "s1800",                   :default => false
    t.boolean  "s1815",                   :default => false
    t.boolean  "s1830",                   :default => false
    t.boolean  "s1845",                   :default => false
    t.boolean  "s1900",                   :default => false
    t.boolean  "s1915",                   :default => false
    t.boolean  "s1930",                   :default => false
    t.boolean  "s1945",                   :default => false
    t.boolean  "s2000",                   :default => false
    t.boolean  "s2015",                   :default => false
    t.boolean  "s2030",                   :default => false
    t.boolean  "s2045",                   :default => false
    t.boolean  "s2100",                   :default => false
    t.boolean  "s2115",                   :default => false
    t.boolean  "s2130",                   :default => false
    t.boolean  "s2145",                   :default => false
    t.boolean  "s2200",                   :default => false
    t.boolean  "s2215",                   :default => false
    t.boolean  "s2230",                   :default => false
    t.boolean  "s2245",                   :default => false
    t.boolean  "s2300",                   :default => false
    t.boolean  "s2315",                   :default => false
    t.boolean  "s2330",                   :default => false
    t.boolean  "s2345",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slot_set_records", ["day_of_week_id"], :name => "ssr_dow_id"
  add_index "slot_set_records", ["service_availability_id"], :name => "srv_avail"

  create_table "sp_salesforce_leads", :force => true do |t|
    t.string   "first_name",    :limit => 100
    t.string   "last_name",     :limit => 100
    t.string   "name",          :limit => 200
    t.string   "phone",         :limit => 15
    t.string   "email",         :limit => 60
    t.string   "url",           :limit => 100
    t.string   "city"
    t.string   "state",         :limit => 2
    t.string   "zip",           :limit => 5
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 :default => 0, :null => false
    t.string   "salesforce_id"
  end

  add_index "sp_salesforce_leads", ["salesforce_id"], :name => "index_sp_salesforce_leads_on_salesforce_id"

  create_table "spent_reward_dollars", :force => true do |t|
    t.integer "amount"
    t.integer "item_id"
    t.integer "reward_dollar_id"
    t.string  "item_type"
    t.boolean "active",           :default => true
  end

  create_table "spent_rewards", :force => true do |t|
    t.integer  "client_id"
    t.integer  "reward_id"
    t.string   "reward_type"
    t.integer  "applied_to_id"
    t.string   "applied_to_type"
    t.integer  "spent_on_id"
    t.string   "spent_on_type"
    t.float    "amount"
    t.boolean  "finalized",       :default => false
    t.boolean  "active",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0,     :null => false
  end

  add_index "spent_rewards", ["active", "reward_id", "reward_type"], :name => "index_spent_rewards_on_active_and_reward_id_and_reward_type"
  add_index "spent_rewards", ["applied_to_id", "applied_to_type"], :name => "applied_to_id"
  add_index "spent_rewards", ["spent_on_id", "spent_on_type"], :name => "spent_on_id"

  create_table "staff_types", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "stock_image_categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
    t.integer  "stock_image_id"
    t.integer  "category_id"
  end

  add_index "stock_image_categories", ["category_id", "stock_image_id"], :name => "stock_image_category_index"
  add_index "stock_image_categories", ["stock_image_id", "category_id"], :name => "stock_image_id_category_id_index"

  create_table "stock_images", :force => true do |t|
    t.integer  "photo_id"
    t.boolean  "sharable",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",     :default => 0,     :null => false
    t.string   "filename"
    t.boolean  "backup_image",     :default => false, :null => false
    t.boolean  "is_default_image", :default => false
  end

  create_table "street_descriptors", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "long_name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "support_logs", :force => true do |t|
    t.integer  "service_provider_id"
    t.integer  "booking_id"
    t.integer  "client_id"
    t.integer  "type_id"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_parameters", :force => true do |t|
    t.string   "parameter_type"
    t.text     "parameter_description"
    t.string   "units"
    t.integer  "default_value",         :limit => 8
    t.integer  "current_value",         :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parameter"
  end

  create_table "temp_availabilities", :force => true do |t|
    t.string  "session_id",    :limit => 254
    t.integer "sp_id"
    t.integer "service_id"
    t.integer "service_score"
    t.integer "sp_score"
  end

  create_table "temp_service_providers", :force => true do |t|
    t.string  "session_id",              :limit => 254
    t.integer "sp_id"
    t.string  "sp_ref",                  :limit => 254
    t.string  "sp_name",                 :limit => 254
    t.string  "sp_street1",              :limit => 254
    t.string  "sp_street2",              :limit => 254
    t.string  "sp_cross_streets",        :limit => 254
    t.integer "zip"
    t.float   "overall_rating"
    t.float   "category_rating"
    t.string  "zone",                    :limit => 254
    t.float   "distance_to_target_zone"
  end

  create_table "temp_services", :force => true do |t|
    t.string  "session_id",          :limit => 254
    t.integer "service_id"
    t.string  "service_ref",         :limit => 254
    t.string  "service_name",        :limit => 254
    t.string  "service_beautybucks", :limit => 254
    t.float   "service_price"
    t.integer "service_duration"
  end

  create_table "temp_zip_codes", :force => true do |t|
    t.integer "zip"
    t.float   "lat"
    t.float   "long"
  end

  create_table "temporal_expressions", :force => true do |t|
    t.string   "dated_obj_type"
    t.integer  "dated_obj_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "start_time"
    t.integer  "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",   :default => 0, :null => false
    t.integer  "wday"
  end

  add_index "temporal_expressions", ["dated_obj_type", "dated_obj_id", "start_date", "end_date", "start_time", "end_time", "wday"], :name => "te_calendar_wday"
  add_index "temporal_expressions", ["dated_obj_type", "dated_obj_id", "start_date", "end_date", "start_time", "end_time"], :name => "te_calendar"
  add_index "temporal_expressions", ["dated_obj_type", "dated_obj_id", "start_date", "end_date", "wday"], :name => "te_search_wday"
  add_index "temporal_expressions", ["dated_obj_type", "dated_obj_id", "start_date", "end_date"], :name => "te_search"

  create_table "time_zone_enums", :force => true do |t|
    t.string  "name"
    t.string  "short_name"
    t.string  "long_name"
    t.integer "utc_offset"
    t.boolean "is_dst",     :default => false
  end

  create_table "tracking_sources", :force => true do |t|
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_campaign"
    t.string   "utm_content"
    t.integer  "tracked_id"
    t.string   "tracked_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "tracking_sources", ["tracked_type", "tracked_id", "utm_source", "utm_medium", "utm_term", "utm_campaign", "utm_content"], :name => "tracked_type"

  create_table "usable_with", :force => true do |t|
    t.integer "usable_id"
    t.string  "usable_type"
    t.integer "reward_code_rule_id"
  end

  create_table "user_login_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_login_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0, :null => false
  end

  add_index "user_login_roles", ["role_id", "user_login_id"], :name => "index_user_login_roles_on_role_id_and_user_login_id"
  add_index "user_login_roles", ["user_login_id", "role_id"], :name => "index_user_login_roles_on_user_login_id_and_role_id"

  create_table "user_logins", :force => true do |t|
    t.string   "user_type"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.datetime "token_expiration"
    t.string   "api_key"
    t.string   "password_digest"
  end

  add_index "user_logins", ["api_key"], :name => "index_user_logins_on_api_key", :unique => true
  add_index "user_logins", ["token"], :name => "index_user_logins_on_token", :unique => true
  add_index "user_logins", ["user_name", "api_key", "token"], :name => "index_user_logins_on_user_name_and_api_key_and_token"
  add_index "user_logins", ["user_name"], :name => "index_user_logins_on_user_name", :unique => true
  add_index "user_logins", ["user_type", "user_id"], :name => "index_user_logins_on_user_type_and_user_id"

  create_table "verisign_credit_cards", :force => true do |t|
    t.string   "acct_num_encrypted"
    t.date     "expiration_date"
    t.integer  "billing_address_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "credit_card_type_id"
    t.boolean  "is_active",                              :default => true
    t.string   "auth_ref_id"
    t.string   "cvv2"
    t.string   "first_name",              :limit => 100
    t.string   "last_name",               :limit => 100
    t.string   "obscured_account_number"
    t.datetime "authorized_at"
    t.string   "braintree_token"
    t.integer  "billed_id"
    t.string   "billed_type"
  end

  create_table "waiting_lists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  create_table "week_in_months", :force => true do |t|
    t.integer  "temporal_expression_id"
    t.integer  "week_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",           :default => 0, :null => false
  end

  create_table "write_offs", :force => true do |t|
    t.string   "created_by_type"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0, :null => false
  end

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
    t.integer  "address_id"
    t.integer  "default_search_radius", :default => 0
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "lb_city_enum_id"
  end

  add_index "zones", ["lb_city_enum_id"], :name => "index_zones_on_lb_city_enum_id"
  add_index "zones", ["parent_id", "lft", "rgt"], :name => "index_zones_on_parent_id_and_lft_and_rgt"

end
