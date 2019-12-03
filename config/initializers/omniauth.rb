Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '843688704421-s7etbjsc50jl8dcuarslibk59hqeqqet.apps.googleusercontent.com', '7BVmJh1glJM-zzrR3hJ0OnT_', skip_jwt: true
end
