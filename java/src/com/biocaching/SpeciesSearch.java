package com.biocaching;
import java.io.*;
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
            if (args.length < 3) {
                System.out.println("Usage:");
                System.out.println("java -cp ... CreateObservationWithPicture <url> <username> <password>");
                System.exit(1);
            }

            String bcURL = String.format("http://%s", args[0]);
            String username = args[1];
            String password = args[2];

            /* Sign in to API, get the authentication token */

            URL url = new URL(String.format("%s/users/sign_in.json", bcURL));
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Accept", "application/json");

            JSONObject params   = new JSONObject();
            JSONObject user = new JSONObject();
            params.put("email", username);
            params.put("password", password);
            user.put("user", params);

            OutputStream os = conn.getOutputStream();
            os.write(user.toString().getBytes("UTF-8"));
            os.flush();

            System.out.println(String.format("Response code from signing in: %d", conn.getResponseCode()));

            if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
                if (conn.getResponseCode() == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    System.out.println("Not authorized, check your username/password");
                    Runtime.getRuntime().exit(1);
                }
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            String output;

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String response = br.readLine();
            JSONObject object = new JSONObject(response);
            String token = object.getString("authentication_token");

            conn.disconnect();

            //Runtime.getRuntime().exit(1);

            System.out.println("Move on to search for species...");

            url = new URL(String.format("%s/api/taxonomies/1/taxa/search.json?term=owl", bcURL));

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("X-User-Email", username);
            conn.setRequestProperty("X-User-Token", token);
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException(String.format("Failed : HTTP error code : %s", conn.getResponseCode()));
            }

            br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            output = "";
            String line;
            System.out.println("Search results .... \n");
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
                System.out.println(arr.getJSONObject(i).getJSONObject("_source"));
                /*
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
                }*/
            }
        } catch (MalformedURLException e) {

            e.printStackTrace();

        } catch (IOException e) {

            e.printStackTrace();

        }

    }

}

