<template>
    <div class="col-12 col-md-8 offset-md-2 col-lg-4 offset-lg-4">
        <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
        <b-form @submit="onSubmit" @reset="onReset">
            <b-form-group
                id="input-group-1"
                label="Email address"
                label-for="input-1"
                :invalid-feedback="formEmailInvalidFeedback"
                :state="formEmailState"
            >
                <b-form-input
                    id="input-1"
                    v-model="person.email"
                    type="email"
                    :state="formEmailState"
                    novalidate
                    @change="onEmailType()"
                ></b-form-input>
            </b-form-group>
            <b-form-group
                id="input-group-2"
                label="Password"
                label-for="input-2"
                description="Passwords must contain: 6 or more characters. Password cannot contain: the word 'password' or your username"
            >
                <b-form-input
                    id="input-2"
                    v-model="person.password"
                    type="password"
                    novalidate
                ></b-form-input>
            </b-form-group>
            <b-button type="submit" variant="primary">Submit</b-button>
            <b-button type="reset">Reset</b-button>
        </b-form>
    </div>
</template>

<script>
import PlanoModel from './model';

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
                    typed: false
                }
            }
        }
    },
    computed: {
      formEmailState: function() {
            if (this.form.email.typed === false) {
                return null;
            }
            return this.person.email.match(/.+@.+\..+/) ? null : false
      },
      formEmailInvalidFeedback: function(){
            if (this.person.email.length > 0) {
            return "Email address needs to be in the correct format\ne.g xyz@test.com"
            }
            return 'You must enter an email address.'
      }
    },
    methods: {
        onEmailType: function(event) {
            this.form.email.typed = true;
        },
        onSubmit: function(event) {
            event.preventDefault();
            if(this.formEmailState) {
                console.log("I clicked submit!")
                const loginInfo = new LoginModel({person: this.person});
                loginInfo.save().then(() => 
                    window.location.href = "/"
                ).catch(error => this.onSaveFailure(error));
            }
        
        },
        onReset: function() {
            event.preventDefault();
            this.form.email = '';
            this.form.password = '';
            this.show = false;
            this.$nextTick(() => this.show = true);
        },
        onSaveFailure: function(error) {
            console.log(error)
            console.log(error.response.response.status)
           if (error.response.response.status === 401) {
               this.error.text = "You have an incorrect username or password."
               this.error.visible = true;
           }
        }
    }
}
</script>
