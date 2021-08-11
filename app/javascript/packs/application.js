// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery") // Optional, pulling this in for Bootstrap 4

// import "@fortawesome/fontawesome-free/js/all";
import 'jquery';
import 'popper.js';
import 'bootstrap';
import 'bootstrap/dist/js/bootstrap';

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import '../stylesheets/custom.scss'
import '../stylesheets/style.scss'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import Vue from 'vue';
import VueRouter from 'vue-router';
import Vuex from 'vuex';
import {BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue';
import { CustomIconsPlugin } from '../icons';

Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);
Vue.use(VueRouter);
Vue.use(CustomIconsPlugin);
Vue.use(Vuex);

// login
import LoginScreen from '../login/login_screen.vue'
import ForgotPassword from '../login/forgot_password.vue'
import PlanLogin from '../login/login.vue';
import NewPassword from '../login/new_password.vue';

const loginRoutes = [
    { path: 'forgot', component: ForgotPassword },
    { path: 'password-reset', component: NewPassword },
    { path: '', component: PlanLogin },
]

// admin

import AdminComponent from '../administration/admin_component.vue';
import { store as admin } from '../administration/admin.store';
import { store as agreementStore } from '../administration/agreement.store'
import { store as settingsStore } from '../administration/configurations.store';
import { store as adminPeopleStore } from '../administration/admin_people.store';

settingsStore.registerAsModuleFor(admin);
agreementStore.registerAsModuleFor(admin);
// TODO use actual people store
adminPeopleStore.registerAsModuleFor(admin);

// people
import PeopleScreen from '../people/people-screen.vue';
import { store  as people } from '../people/people.store';

// surveys
import SurveyScreen from '../surveys/survey-screen.vue';
import SurveyList from '../surveys/survey-list.vue';
import EditSurvey from '../surveys/edit-survey.vue';
import TakeSurvey from '../surveys/take-survey.vue';
import SurveyPage from '../surveys/survey-page.vue';
import SurveyThankYou from '../surveys/survey-thank-you.vue';
import { store as surveys } from '../surveys/survey.store'

const surveyRoutes = [
  { path: 'edit/:id/:responses', component: EditSurvey, props: true},
  { path: 'edit/:id', component: EditSurvey, props: true },
  { path: ':survey_id/page/:id/:preview', component: SurveyPage, props: true},
  { path: ':survey_id/page/:id', component: SurveyPage, props: true},
  { path: ':id/thankyou', component: SurveyThankYou, props: true},
  { path: ':id/:preview', component: TakeSurvey, props: true },
  { path: ':id', component: TakeSurvey, props: true},
  { path: '', component: SurveyList },
]

// main
import PlanoramaApp from '../app.vue';
import { store as appStore } from '../store';
const store = appStore.initialize(Vuex);
admin.registerAsModuleFor(store);
people.registerAsModuleFor(store);
surveys.registerAsModuleFor(store);

const router = new VueRouter({
  routes: [
    { path: '/login', component: LoginScreen, children: loginRoutes },
    { path: '/admin', component: AdminComponent},
    { path: '/people', component: PeopleScreen},
    { path: '/surveys', component: SurveyScreen, children: surveyRoutes },
  ]
});

const app = new Vue({
  components: { PlanoramaApp },
  router,
  store
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#app');
})
