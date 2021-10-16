
// login 
import LoginScreen from './login/login_screen.vue'
import ForgotPassword from './login/forgot_password.vue'
import PlanLogin from './login/login.vue';
import NewPassword from './login/new_password.vue';

const loginRoutes = [
    { path: 'forgot', component: ForgotPassword },
    { path: 'password-reset', component: NewPassword },
    { path: '', component: PlanLogin, name: "login" },
]

// admin 
import AdminComponent from './administration/admin_component.vue';

// people
import PeopleScreen from './people/people-screen.vue';

// surveys
/*
import SurveyScreen from './surveys/survey-screen.vue';
import SurveyList from './surveys/survey-list.vue';
import EditSurvey from './surveys/edit-survey.vue';
import TakeSurvey from './surveys/take-survey.vue';
import SurveyPage from './surveys/survey-page.vue';
import SurveyThankYou from './surveys/survey-thank-you.vue';

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
*/
import SurveyScreen from './surveys2/survey-screen.vue';

// dashboard
import Dashboard from './dashboard/dashboard.vue';

// main
import Vue from 'vue';
import VueRouter from 'vue-router';
Vue.use(VueRouter);

export const router = new VueRouter({
  routes: [
    { path: '/login', component: LoginScreen, children: loginRoutes },
    { path: '/admin', component: AdminComponent},
    { path: '/people', component: PeopleScreen},
    { path: '/surveys', component: SurveyScreen},
   // { path: '/surveys', component: SurveyScreen, children: surveyRoutes },
    { path: '', component: Dashboard}
  ]
});
