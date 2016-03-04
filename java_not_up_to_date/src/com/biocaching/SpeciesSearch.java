package com.biocaching;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import org.json.*;

/*
  $ wget http://central.maven.org/maven2/org/json/json/20151123/json-20151123.jar
  $ javac -cp json-20151123.jar SpeciesSearch.java
  $ java -cp json-20151123.jar:. SpeciesSearch
*/

public class SpeciesSearch {

    // http://localhost:8080/RESTfulExample/json/product/get
    public static void main(String[] args) {

        try {

            URL url = new URL("http://api.biocaching.com:81/taxonomies/1/taxa/search.json?term=fox");

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            String userpass = "bc:Oslo2016";
            String basicAuth = "Basic " + javax.xml.bind.DatatypeConverter.printBase64Binary(userpass.getBytes());
            conn.setRequestProperty ("Authorization", basicAuth);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            String output="";
            String line;
            System.out.println("Output from Server .... \n");
            while ((line = br.readLine()) != null) {
                output += line;
            }

            conn.disconnect();

            System.out.println(output);

            JSONObject obj = new JSONObject(output);
            System.out.println(String.format("Total number of hits: %d", Integer.parseInt(obj.get("total").toString())));
            System.out.println(String.format("Number of hits returned: %d", Integer.parseInt(obj.get("number_of_hits").toString())));

            //System.out.println(obj.get("hits").getClass().getName());
            JSONArray arr = obj.getJSONArray("hits");
            for (int i = 0; i < arr.length(); i++)
            {
                JSONArray common_names = arr.getJSONObject(i).getJSONObject("_source").getJSONArray("common_names");
                String scientific_name = arr.getJSONObject(i).getJSONObject("_source").getString("scientific_name");

                String common_name_highlight = "";
                if (arr.getJSONObject(i).getJSONObject("highlight").has("common_names.name")) {
                    common_name_highlight = arr.getJSONObject(i).getJSONObject("highlight").getJSONArray("common_names.name").getString(0);
                }
                String scientific_name_highlight = "";
                if (arr.getJSONObject(i).getJSONObject("highlight").has("scientific_name")) {
                    scientific_name_highlight = arr.getJSONObject(i).getJSONObject("highlight").getJSONArray("scientific_name").getString(0);
                }
                //JSONArray tmp = arr.getJSONObject(i).getJSONObject("highlight").getJSONArray("scientific_name");
                //String scientific_name_highlight = .toString();
                if (common_names.length() > 0) {
                    String str = String.format("%s (%s) highlight : %s, %s",
                            common_names.getJSONObject(0).getString("name"),
                            scientific_name, common_name_highlight, scientific_name_highlight);
                    System.out.println(str);
                }
            }
        } catch (MalformedURLException e) {

            e.printStackTrace();

        } catch (IOException e) {

            e.printStackTrace();

        }

    }

}

