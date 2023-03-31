<template>
  <div class="new-account">
    <h3>Create Account</h3>
    <p>
      Enter your email address below to either create an account or reset your
      password.
    </p>
    <p>
      If an account with this address exists, you will receive an email with a
      link to complete the password process. If one does not, you will receive a
      link to create your account.
    </p>
    <b-alert :show="alert.visible" :variant="alert.variant">{{
      alert.text
    }}</b-alert>
    <b-form @submit="onSubmit">
      <email-field
        v-model="person.email"
        @validated="form.email.valid = $event"
        :validateNow="form.email.validate"
      ></email-field>
      <div class="d-flex flex-row-reverse mb-2" v-if="captchaKey">
        <vue-recaptcha
            ref="recaptcha" 
            :sitekey="captchaKey"
            :loadRecaptchaScript="true"
            @verify="onVerifyCaptcha"
            @error="onCaptchaError"
        ></vue-recaptcha>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button
          :disabled="submitDisabled"
          type="submit"
          variant="primary"
          class="px-5"
          >Send me a link</b-button
        >
      </div>
    </b-form>
  </div>
</template>

<script>
import EmailField from "../shared/email_field";
import { http } from "../http";
import { validateFields } from "../utils";
import {
  LOGIN_INVALID_FIELDS,
  SOMETHING_WENT_WRONG,
} from "../constants/strings";
import settingsMixin from "@/store/settings.mixin";
import VueRecaptcha from 'vue-recaptcha';

export default {
  name: "CreateAccount",
  mixins: [settingsMixin],
  props: ['redirect'],
  data: () => ({
    person: {
      email: "",
    },
    alert: {
      variant: "danger",
      visible: false,
      text: "",
    },
    successfullySent: false,
    form: {
      email: {
        valid: null,
        validate: null,
      },
    },
  }),
  components: {
    EmailField,
    VueRecaptcha
  },
  computed: {
    submitDisabled: function () {
      return this.form.email.valid === false;
    },
    captchaKey: function() {
      return this.currentSettings.recaptcha_site_key
    }
  },
  methods: {
    onVerifyCaptcha: function (response) {
      // console.log('Verify: ' + response)
      this.captcha_response = response;
    },
    onCaptchaError: function() {
      // We got an error from captcha
    },
    onSubmit: async function (event) {
      event.preventDefault();
      await validateFields(this.form.email);
      if (this.form.email.valid === false) {
        this.error.text = LOGIN_INVALID_FIELDS;
        this.error.visible = true;
      } else {
        // We need the URL of the destination if any that the user is going to be sent to
        // This would, for example, be the survey
        let destination = null;
        if (this.redirect) {
          destination = window.location.origin + this.redirect;
        }

        http
          .post("/login/sign_up", { email: this.person.email, url: destination, captcha_response: this.captcha_response })
          .then((data) => {
            // console.debug("***** created ", data)
            this.successfullySent = data.status === 201;
            if (this.successfullySent) {
              this.$router.push("/?alert=reset_sent");
            } else {
              this.alert.text = SOMETHING_WENT_WRONG(
                this.configByName("email_reply_to_address")
              );
              this.alert.visible = true;
            }
          })
          .catch((error) => {
            const errors = error.response.data.errors;
            console.debug("ERROR: ", error.response)

            if (error.response.status == 422) {
              const errors = error.response.data.errors;

              this.alert.text = errors[0].title;
              this.alert.visible = true;
            } else {
              // Even if we have a problem we need to pretend that we do not
              this.$router.push("/?alert=reset_sent");
            }
          });
      }
    },
  },
  mounted() {
    this.captcha_response = null
  }
};
</script>
