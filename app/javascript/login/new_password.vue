<template>
    <div class="new-password">
        <h3>Reset Password</h3>
        <p>In order to protect your account, make sure your password:</p>
        <ul>
            <li>Is 6 or more characters</li>
            <li>Does not contain the word "password"</li>
            <li>Does not contain your email address</li>
            <li>Is not a member of this <a>TODO list of common passwords TODO</a></li>
        </ul>
        <p>Optionally, we recommend you follow the <a>TODO Correct Horse Battery Staple TODO</a> paradigm.</p>
        <b-form @submit="onSubmit">
            <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
            <login-password-field v-model="person.password" :new-password="true" @validated="form.password.valid = $event"></login-password-field>
            <login-password-field v-model="person.password_confirmation" :confirmation="true" :must-match="person.password" @validated="form.passwordConfirmation.valid = $event"></login-password-field>
            <div class="d-flex flex-row-reverse">
                <b-button type="submit" variant="primary" class="px-5">Change Password</b-button>
            </div>
        </b-form>
    </div>
</template>

<script>
import { http } from '../http';
import { SOMETHING_WENT_WRONG } from '../constants/errors';
import LoginPasswordField from './login_password_field';

export default {
    name: "NewPassword",
    components: {
        LoginPasswordField,
    },
    data: () => ({
        person: {
            password: '',
            password_confirmation: '',
            reset_password_token: '',
        },
        error: {
            visible: false,
            text: ''
        },
        form: {
            password: {
                valid: null
            }, 
            passwordConfirmation: {
                valid: null
            }
        }
    }),
    mounted: function() {
        this.person.reset_password_token = this.$route.query.reset_password_token
    },
    methods: {
        onSubmit: function(event) {
            event.preventDefault();
            if(this.form.password.valid === false || this.form.passwordConfirmation.valid === false) {
                this.error.text = "TODO WRITE THIS COPY"
                this.error.visible = true;
            } else {
                console.log("submit password change here!")
                http.put("/people/password.json", {person: this.person}).then( data => {
                    if (data.status === 204) {
                        this.$router.push('/')
                    } else {
                        console.log(data);
                        this.error.text = SOMETHING_WENT_WRONG
                        this.error.visible = true
                    }
                }).catch((error, result) =>  {
                    if(error.response.data.errors) {
                        console.log(error.response.data.errors, "needs to show instead TODO")
                    }
                    this.error.text = SOMETHING_WENT_WRONG
                    this.error.visible = true
                });
            }
        }
    }
}
</script>
