<template>
    <div class="login">
        <b-alert :show="alert.visible" variant="success" dismissible>{{ alert.text }}</b-alert>
        <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
        <b-form @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event" :validateNow="form.email.validate"></login-email-field>
            <login-password-field v-model="person.password" @validated="form.password.valid = $event" :validateNow="form.password.validate"></login-password-field>
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

import { validateFields } from '../utils';

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
            alert: {
                visible: false,
                text: ''
            },
            form: {
                email: {
                    valid: null,
                    validate: null
                },
                password: {
                    valid: null,
                    validate: null
                }
            }
        }
    },
    components: {
        LoginEmailField,
        LoginPasswordField,
    },
    mounted: function() {
        if (this.$route.query.alert) {
            this.alert.text = this.$route.query.alert;
            this.alert.visible = true;
        }
    },
    methods: {
        onSubmit: async function(event) {
            event.preventDefault();
            await validateFields(this.form.email, this.form.password);
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
