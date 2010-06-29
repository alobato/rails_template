Factory.define :valid_user, :class => User do |u|
  # TODO: Implementar corretamente a factory
  u.email "email@email.com"
  u.crypted_password '49b4d35a1f595320ba4c55afe0ed7b7aca4792382c25bbe4c4b908e7fb789f7472dcdf3aa0a0c031e61f4226b66755503811095d08ea67dfbce392cdce1a1e8f'
  u.password_salt 'JiOOoHqrzx_WH4ykn2ac'
  u.persistence_token '1b8c3ba24db5fb90c91f1e2ca337ee02892705368a35395a0a3447b4928526facbf5b72d5e8b4a865095cea99b7ec892e4206dbe3f71ec13efbfbdd0dbcd8821'
  u.single_access_token '6SC5ciABvMDwqxPN4tv1'
  u.perishable_token 'UX53fcgSdVmh-yTB5gJe'
  u.activation_code '0d7aaa9568'
  u.activated_at '2010-06-29 02:21:09'
end

Factory.define :invalid_user , :class => User do |u|
  u.email "mail.com"
  u.password "123"
  u.password_confirmation '123'
end
