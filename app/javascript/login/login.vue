<template>
  <div class="login">
    <login-small-print></login-small-print>
    <b-alert :show="alert.visible" variant="success" dismissible>{{
      alert.text
    }}</b-alert>
    <b-alert :show="error.visible" variant="danger">{{ error.text || error.asyncText() }}</b-alert>
    <b-form @submit="onSubmit">
      <email-field
        v-model="person.email"
        @validated="form.email.valid = $event"
        :validateNow="form.email.validate"
      ></email-field>
      <login-password-field
        v-model="person.password"
        @validated="form.password.valid = $event"
        :validateNow="form.password.validate"
        :validation="false"
      ></login-password-field>
      <div class="d-flex flex-row-reverse mb-3">
        <router-link :to="'/login/forgot?redirect=' + redirect">Zapomniałeś hasła?</router-link>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5">Zaloguj</b-button>
      </div>
    </b-form>
    <!--iea-modal @cancel="onIeaCancel" @ok="onIeaAgree"></iea-modal-->
    <div class="d-flex flex-column mb-3">
      <router-link :to="'/login/forgot?redirect=' + redirect">Nigdy nie ustawiłeś hasła? Ustaw je teraz</router-link>
      <router-link :to="'/login/new?redirect=' + redirect">Utwórz konto</router-link>
    </div>
    <login-integrations :redirect="redirect"></login-integrations>
  </div>
</template>

<script>
import EmailField from "@/shared/email_field.vue";
import LoginPasswordField from "./login_password_field.vue";
import LoginSmallPrint from './login_small_print.vue';
import LoginIntegrations from "./login_integrations.vue";
import IeaModal from './iea-modal';
import axios from 'axios';
import {
  authMixin,
  personSessionMixin
} from '@mixins';

import { validateFields } from "@/utils";

import {
  LOGIN_401,
  LOGIN_MISSING_PASSWORD,
  LOGIN_INVALID_FIELDS,
  LOGIN_PASSWORD_RESET_EMAIL_SEND,
  LOGIN_PASSWORD_CHANGED,
  IEA_FAILURE_TO_SIGN,
  LOGIN_NO_ROLE
} from "@/constants/strings";
import { settingsMixin } from "@/mixins";
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';


export default {
  name: "PlanLogin",
  props: ['redirect'],
  data() {
    return {
      person: {
        email: "",
        password: "",
      },
      error: {
        visible: false,
        text: "",
        asyncText: () => ""
      },
      alert: {
        visible: false,
        text: "",
      },
      form: {
        email: {
          valid: null,
          validate: null,
        },
        password: {
          valid: null,
          validate: null,
        },
      },
    };
  },
  components: {
    EmailField,
    LoginPasswordField,
    LoginSmallPrint,
    IeaModal,
    LoginIntegrations,
  },
  mixins: [authMixin, personSessionMixin, settingsMixin, loginIntegrationsMixin],
  mounted: function () {
    if (this.$route.query.alert) {
      this.showAlert(this.$route.query.alert);
    }
  },
  computed: {
    helpEmail() {
      return this.configByName("email_reply_to_address");
    }
  },
  watch: {
    ['$route.query'](newval) {
      if(newval.alert) {
        this.showAlert(newval.alert)
      }
    }
  },
  methods: {
    onSubmit(event) {
      event.preventDefault();
      // It sure seems like we're validating password here. but we're not
      // however if we don't go through the validation process, the form won't submit
      // it is skipping the actual validation internally though
      validateFields(this.form.email, this.form.password).then(() => {
        if (
          this.form.email.valid === false ||
          this.form.password.valid === false
        ) {
          this.error.text = LOGIN_INVALID_FIELDS;
          this.error.visible = true;
        } else {
          axios.post('/auth/sign_in', {person: this.person})
            .then(() => this.$bvModal.show('iea-modal'))
            .then(() => this.fetchSession())
            .catch((error) => this.onSaveFailure(error));
        }
      })
    },
    onSaveFailure: function (error) {
      this.error.text = error.message;
      if (error.message === "Request failed with status code 401") {
        this.error.text = LOGIN_401;
      }
      this.error.visible = true;
    },
    onIeaAgree() {
      window.location.href = "#"
    },
    onIeaCancel() {
      this.signOut().finally(() => {
        this.error.text = IEA_FAILURE_TO_SIGN;
        this.error.visible = true;
      })
    },
    showAlert(queryAlert) {
      switch (queryAlert) {
        case "reset_sent":
          this.alert.text = LOGIN_PASSWORD_RESET_EMAIL_SEND;
          this.alert.visible = true;
          break;
        case "password_changed":
          this.alert.text = LOGIN_PASSWORD_CHANGED;
          this.alert.visible = true;
          break;
        case "no_role":
          this.error.asyncText = () => LOGIN_NO_ROLE(this.helpEmail);
          this.error.visible = true;
          break;
        default:
          this.error.visible = false;
          this.alert.visible = false;
      }
    }
  },
};
</script>

<style lang="scss" scoped>
</style>
