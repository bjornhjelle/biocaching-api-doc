First: 

keytool -import -alias biocaching -keystore cacerts -file ssl_public_cert/cert.pem 

To build and run from the command line: 

$ ./gradlew build

To create an observation with a picture on the Biocaching server: 

$ ./gradlew run -Djavax.net.ssl.trustStore=cacerts -Dexec.args="https://api.biocaching.com <USERNAME> <PASSWORD> <API-KEY>"

To create an observation with a picture in dev: 

$ ./gradlew run -Dexec.args="http://localhost <USERNAME> <PASSWORD> <API-KEY>"




To build and run from intellij: 

    * use "File, Open", and then select the build.gradle fil 