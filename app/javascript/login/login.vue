<template>
    <div class="login">
        <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
        <b-form @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event"></login-email-field>
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
            <div class="d-flex flex-row-reverse">
                <router-link to="/forgot">Forgot Password</router-link>
            </div>
            <div class="d-flex flex-row-reverse">
                <b-button type="submit" variant="primary" class="px-5">Log In</b-button>
            </div>
        </b-form>
    </div>
</template>

<script>
import PlanoModel from '../model';
import LoginEmailField from './login_email_field';

import {
    LOGIN_401,
    LOGIN_MISSING_PASSWORD,
    LOGIN_INVALID_FIELDS,
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
    components: {
        LoginEmailField,
    },
    methods: {
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
        onSaveFailure: function(error) {
           if (error.response.response.status === 401) {
               this.error.text = LOGIN_401
               this.error.visible = true;
           }
        }
    }
}
</script>
