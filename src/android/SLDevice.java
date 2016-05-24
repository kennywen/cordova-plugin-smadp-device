package com.silverlake.plugin;

import android.provider.Settings;

import com.ecosystem.mobility.silverlake.slmobilesdk.security.rootchecker.SLRootCheck;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class SLDevice extends CordovaPlugin {

  @Override
  public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
    if (action.equals("isGenuine")) {
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          checkRoot(callbackContext);
        }
      });
      return true;
    } else if (action.equals("uuidForDevice")) {
      this.cordova.getThreadPool().execute(new Runnable() {

        @Override
        public void run() {
          getUUID(callbackContext);
        }
      });
      return true;
    }

    return false;
  }

  private void checkRoot(CallbackContext callbackContext) {
    callbackContext.success(String.valueOf(!SLRootCheck.isDeviceRooted()));
  }

  private void getUUID(CallbackContext callbackContext) {
    String uuid = Settings.Secure.getString(this.cordova.getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);
    callbackContext.success(uuid);
  }
}
