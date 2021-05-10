<template>
    <div class="col-12 col-sm-8 offset-sm-2 col-lg-4 offset-lg-4">
        <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
        <b-form @submit="onSubmit" @reset="onReset">
            <b-form-group
                id="input-group-1"
                label="Email address"
                label-for="input-1"
                :invalid-feedback="formEmailInvalidFeedback"
                :state="form.email.valid"
            >
                <b-form-input
                    id="input-1"
                    v-model="person.email"
                    type="text"
                    :state="form.email.valid"
                    novalidate
                    @focus="onEmailFocus"
                    @blur="onEmailUnfocus"
                ></b-form-input>
            </b-form-group>
            <b-form-group
                id="input-group-2"
                label="Password"
                label-for="input-2"
                :invalid-feedback="form.password.invalidMessage"
                :state="form.password.valid"
                description="Passwords must contain: 6 or more characters. Password cannot contain: the word 'password' or your username"
            >
                <b-form-input
                    id="input-2"
                    v-model="person.password"
                    type="password"
                    novalidate
                    :state="form.password.valid"
                    @focus="onPasswordFocus"
                    @blur="onPasswordUnfocus"
                ></b-form-input>
            </b-form-group>
            <b-button type="submit" variant="primary">Submit</b-button>
            <b-button type="reset">Reset</b-button>
        </b-form>
    </div>
</template>

<script>
import PlanoModel from '../model';

import {
    LOGIN_401,
    LOGIN_MISSING_PASSWORD,
    LOGIN_INVALID_FIELDS,
    LOGIN_MISSING_EMAIL,
    LOGIN_NOT_AN_EMAIL,
} from '../constants/errors';

export class LoginModel extends PlanoModel {
    default() {
        return {
            commit: 'Log in',
            person: {
                email: '',
                password: ''
            }
        }
    }
    routes() {
        return {
            save: '/people/sign_in.json'
        }
    }
}

export default {
    name: "PlanLogin",
    data() {
        return {
            person: {
                email: '',
                password: '',
            },
            error: {
                visible: false,
                text: ''
            },
            form: {
                email: {
                    valid: null
                },
                password: {
                    valid: null,
                    invalidMessage:  LOGIN_MISSING_PASSWORD
                }
            }
        }
    },
    computed: {
      formEmailInvalidFeedback: function(){
            if (this.person.email.length > 0) {
                return LOGIN_NOT_AN_EMAIL
            }
            return LOGIN_MISSING_EMAIL
      },
    },
    methods: {
        onEmailUnfocus: function(event) {
            if(!this.person.email.match(/.+@.+\..+/)) {
                this.form.email.valid = false;
            }
        },
        onEmailFocus: function(event) {
            this.form.email.valid = null;
        },
        onPasswordFocus: function(event) {
            this.form.password.valid = null;
        },
        onPasswordUnfocus: function(event) {
            if(this.person.password.length < 1) {
                this.form.password.valid = false;
            }
        },
        onSubmit: function(event) {
            event.preventDefault();
            if(this.form.email.valid === false || this.form.password.valid === false) {
                this.error.text = LOGIN_INVALID_FIELDS;
                this.error.visible = true;
            } else {
                const loginInfo = new LoginModel({person: this.person});
                loginInfo.save().then(() => 
                    window.location.href = "/"
                ).catch(error => this.onSaveFailure(error));
            }
        
        },
        onReset: function() {
            event.preventDefault();
            this.person.email = '';
            this.person.password = '';
            this.form.email.valid = null;
            this.form.password.valid = null;
            this.show = false;
            this.$nextTick(() => this.show = true);
        },
        onSaveFailure: function(error) {
           if (error.response.response.status === 401) {
               this.error.text = LOGIN_401
               this.error.visible = true;
           }
        }
    }
}
</script>
