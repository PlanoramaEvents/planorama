<template>
  <div class="new-account">
    <h3>Utwórz Konto</h3>
    <p>Podaj swój adres e-mail poniżej, aby utworzyć nowe konto lub zresetować hasło.</p>
    <p>
      Jeśli istnieje konto powiązane z tym adresem, otrzymasz e-mail z linkiem umożliwiającym zresetowanie hasła. W przeciwnym razie otrzymasz link do utworzenia nowego konta.
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
      <div class="d-flex mb-2" v-if="captchaKey">
        <vue-recaptcha
            ref="recaptcha"
            :sitekey="captchaKey"
            :loadRecaptchaScript="true"
            @verify="onVerifyCaptcha"
            @expired="onCaptchaError"
            @error="onCaptchaError"
        ></vue-recaptcha>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button
          :disabled="submitDisabled"
          type="submit"
          variant="primary"
          class="px-5"
          >Wyślij mi link</b-button
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
  VALID_CAPTCHA_REQUIRED,
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
    captcha_response: null,
    captcha_errored: false
  }),
  components: {
    EmailField,
    VueRecaptcha
  },
  computed: {
    submitDisabled: function () {
      if (this.currentSettings.recaptcha_site_key) {
        return this.captcha_errored || this.captcha_response == null || this.form.email.valid === false
      } else {
        console.log('submitDisabled: check email')
        return this.form.email.valid === false;
      }
    },
    captchaKey: function() {
      return this.currentSettings.recaptcha_site_key
    }
  },
  methods: {
    onVerifyCaptcha: function (response) {
      console.log('Verify: ' + response)
      this.captcha_response = response;
      this.captcha_errored = false;
    },
    onCaptchaError: function() {
      // We got an error from captcha
      this.captcha_errored = true;
    },
    onSubmit: async function (event) {
      event.preventDefault();

      await validateFields(this.form.email);
      if (this.form.email.valid === false) {
        // This does not do anything @gail - verify
        // this.error.text = LOGIN_INVALID_FIELDS;
        // this.error.visible = true;
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
            // console.debug("ERROR: ", error.response)

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
  }
};
</script>
