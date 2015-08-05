git clone https://github.com/westerndevs/western-devs-website.git
sed -i 's/www.westerndevs.com/[resourceGroup].westus.cloudapp.azure.com:4000/g' western-devs-website/_config.yml
docker run -t -p 4000:4000 -v ~/western-devs-website:/root/jekyll abarylko/western-devs:v1 sh -c 'bundle install && jekyll serve --host 0.0.0.0 --force_polling'