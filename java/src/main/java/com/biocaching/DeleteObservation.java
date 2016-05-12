package com.biocaching;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import org.json.*;

/*
  $ wget http://central.maven.org/maven2/org/json/json/20151123/json-20151123.jar
  $ javac -cp json-20151123.jar DeleteObservation.java
  $ java -cp json-20151123.jar:. DeleteObservation
*/

public class DeleteObservation {

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
            System.out.println(response);
            JSONObject object = new JSONObject(response);
            String token = object.getString("authentication_token");
            long user_id = object.getLong("id");

            conn.disconnect();

            //Runtime.getRuntime().exit(1);

            System.out.println("Move on to delete the observation...");

            //url = new URL(String.format("%s/api/observations", bcURL));
            url = new URL(String.format("%s/api/observations/7", bcURL));

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestProperty("X-User-Email", username);
            conn.setRequestProperty("X-User-Token", token);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");


            if (conn.getResponseCode() != 200) {
                throw new RuntimeException(String.format("Failed : HTTP error code : %s", conn.getResponseCode()));
            }

            br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            output = "";
            String line;
            System.out.println("Response from delete: \n");
            while ((line = br.readLine()) != null) {
                output += line;
            }

            conn.disconnect();
            System.out.println(output);

        } catch (MalformedURLException e) {

            e.printStackTrace();

        } catch (IOException e) {

            e.printStackTrace();

        }

    }

}



