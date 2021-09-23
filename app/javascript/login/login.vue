<template>
  <div class="login">
    <b-alert :show="alert.visible" variant="success" dismissible>{{
      alert.text
    }}</b-alert>
    <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
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
      ></login-password-field>
      <div class="pt-3"><small>{{LOGIN_CLICK_TO_AGREE}} <privacy-policy-link></privacy-policy-link>.</small></div>
      <div class="d-flex flex-row-reverse">
        <router-link to="/forgot">Forgot Password</router-link>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5">Log In</b-button>
      </div>
    </b-form>
    <iea-modal @cancel="onIeaCancel" @ok="onIeaAgree"></iea-modal>
  </div>
</template>

<script>
import {PlanoModel} from "../model";
import EmailField from "../shared/email_field";
import LoginPasswordField from "./login_password_field";
import PrivacyPolicyLink from "../administration/privacy_policy_link"
import authMixin from '../auth.mixin';
import IeaModal from './iea-modal';
import sessionMixin from '../session/session.mixin';

import { validateFields } from "../utils";
import {jwtToken, setJWTToken} from '../utils/jwt_utils';

import {
  LOGIN_401,
  LOGIN_MISSING_PASSWORD,
  LOGIN_INVALID_FIELDS,
  LOGIN_PASSWORD_RESET_EMAIL_SEND,
  LOGIN_PASSWORD_CHANGED,
  LOGIN_CLICK_TO_AGREE,
  IEA_FAILURE_TO_SIGN
} from "../constants/strings";
import { http } from '../http';

export class LoginModel extends PlanoModel {
  default() {
    return {
      commit: "Log in",
      person: {
        email: "",
        password: "",
      },
    };
  }

  getDefaultHeaders() {
    // on save we do not want a jwt token to be sent
    let res = {}
    return res
  }

  routes() {
    return {
      save: "/auth/sign_in",
    };
  }
}

export default {
  name: "PlanLogin",
  data() {
    return {
      LOGIN_CLICK_TO_AGREE,
      person: {
        email: "",
        password: "",
      },
      error: {
        visible: false,
        text: "",
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
    PrivacyPolicyLink,
    IeaModal,
  },
  mixins: [authMixin, sessionMixin],
  mounted: function () {
    if (this.$route.query.alert) {
      switch (this.$route.query.alert) {
        case "reset_sent":
          this.alert.text = LOGIN_PASSWORD_RESET_EMAIL_SEND;
          this.alert.visible = true;
          break;
        case "password_changed":
          this.alert.text = LOGIN_PASSWORD_CHANGED;
          this.alert.visible = true;
          break;
        default:
          this.alert.visible = false;
      }
    }
  },
  methods: {
    onSubmit: async function (event) {
      event.preventDefault();
      await validateFields(this.form.email, this.form.password);
      if (
        this.form.email.valid === false ||
        this.form.password.valid === false
      ) {
        this.error.text = LOGIN_INVALID_FIELDS;
        this.error.visible = true;
      } else {
        const loginInfo = new LoginModel({ person: this.person });
        loginInfo
          .save()
          .then((m) => { setJWTToken(m.response.headers['authorization']) })
          .then(() => this.$bvModal.show('iea-modal'))
          .then(() => this.fetchSession())
          .catch((error) => this.onSaveFailure(error));
      }
    },
    onSaveFailure: function (error) {
      if (error.response.response.status === 401) {
        this.error.text = LOGIN_401;
        this.error.visible = true;
      }
    },
    onIeaAgree() {
      window.location.href = "#"
    },
    onIeaCancel() {
      this.signOut().finally(() => {
        this.error.text = IEA_FAILURE_TO_SIGN;
        this.error.visible = true;
      })
    }
  },
};
</script>
