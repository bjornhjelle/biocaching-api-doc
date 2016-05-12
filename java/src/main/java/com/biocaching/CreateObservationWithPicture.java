package com.biocaching;

/**
 * Created by bjorn on 13/03/16.
 */

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.json.*;
import org.apache.http.client.methods.HttpPost;

import java.io.*;

public class CreateObservationWithPicture {

    public static void main(String[] args) throws UnsupportedEncodingException, IOException {

        if (args.length < 3) {
            System.out.println("Usage:");
            System.out.println("java -cp ... CreateObservationWithPicture <url> <username> <password>");
            System.exit(1);
        }

        String bcSigninURL = String.format("http://%s/users/sign_in", args[0]);
        String bcObservationsURL = String.format("http://%s/observations", args[0]);
        String username = args[1];
        String password = args[2];


        JSONObject userParams   = new JSONObject();
        JSONObject user = new JSONObject();
        userParams.put("email", username);
        userParams.put("password", password);
        user.put("user", userParams);


        CloseableHttpClient httpClient = HttpClientBuilder.create().build();

        String token = null;
        try {
            HttpPost request = new HttpPost(bcSigninURL);
            StringEntity params = new StringEntity(user.toString());
            request.addHeader("content-type", "application/json");
            request.addHeader("X-User-Api-Key", "621f85bdc3482ec12991019729aa9315");
            request.addHeader("Accept", "application/json");
            request.addHeader("Referer", "http://localhost");
            request.setEntity(params);
            CloseableHttpResponse response = httpClient.execute(request);
            if (response != null) {
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        (response.getEntity().getContent())));

                String output = "";
                String line;
                System.out.println("Response from sign in: \n");
                while ((line = br.readLine()) != null) {
                    output += line;
                }
                System.out.println(output);

                JSONObject object = new JSONObject(output);
                token = object.getString("authentication_token");

            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            Runtime.getRuntime().exit(1);
        }


        System.out.println(String.format("Got token, ready to create observation: %s", token));

        try {
            HttpPost request = new HttpPost(bcObservationsURL);
            request.addHeader("content-type", "application/json; charset=UTF-8");
            request.addHeader("Accept", "application/json");
            request.addHeader("Referer", "http://localhost");
            //request.addHeader("X-User-Api-Key", "621f85bdc3482ec12991019729aa9315");
            request.addHeader("X-User-Email", username);
            request.addHeader("X-User-Token", token);

            File file = new File("greylag_3.JPG");

            MultipartEntityBuilder builder = MultipartEntityBuilder.create();

            builder.addBinaryBody("observation[picture_attributes[picture]]", file, ContentType.create("image/jpg"), file.getName());
            //builder.addBinaryBody("observation[picture]", file);
            //builder.addPart("observation[picture]", new FileBody(new File("piggsvin.jpg")));

            builder.addTextBody("observation[taxon_id]", "31619");
            builder.addTextBody("observation[latitude]", "59.8");
            builder.addTextBody("observation[longitude]", "14.2");
            builder.addTextBody("observation[observed_at]", "2016-03-12 18:00:07 +0100");
            builder.addTextBody("observation[comments][]", "Created by Java program");

            HttpEntity multipart = builder.build();
            request.setEntity(multipart);

            HttpPost method = new HttpPost(bcObservationsURL);
            method.setEntity(multipart);
            // for some reason this must be set after setting multipart:
            method.addHeader("X-User-Api-Key", "621f85bdc3482ec12991019729aa9315");

            CloseableHttpResponse response = httpClient.execute(method);

            if (response != null) {
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        (response.getEntity().getContent())));

                String output = "";
                String line;
                System.out.println("Response from create: \n");
                while ((line = br.readLine()) != null) {
                    output += line;
                }
                System.out.println(output);

                JSONObject object = new JSONObject(output);

            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        } finally {
            httpClient.close();
        }
    }
}
