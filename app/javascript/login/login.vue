<template>
    <div class="login">
        <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
        <b-form @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event"></login-email-field>
            <login-password-field v-model="person.password" @validated="form.password.valid = $event"></login-password-field>
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
import LoginPasswordField from './login_password_field';

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
                    valid: null
                }
            }
        }
    },
    components: {
        LoginEmailField,
        LoginPasswordField,
    },
    methods: {
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
