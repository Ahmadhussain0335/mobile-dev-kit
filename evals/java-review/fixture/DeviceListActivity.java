package com.example.legacy;

import android.content.Context;
import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class DeviceListActivity extends AppCompatActivity {

    static Context appContext;

    private TextView statusView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_list);
        appContext = this;
        statusView = findViewById(R.id.status);
        statusView.setText(loadStatus());
    }

    private String loadStatus() {
        try {
            URL url = new URL("https://api.example.com/v1/status");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                return reader.readLine();
            } finally {
                connection.disconnect();
            }
        } catch (Exception e) {
            return "offline";
        }
    }
}
