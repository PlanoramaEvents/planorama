
// login
import LoginScreen from './login/login_screen.vue'
import ForgotPassword from './login/forgot_password.vue'
import PlanLogin from './login/login.vue';
import NewPassword from './login/new_password.vue';
import CreateAccount from './login/create_account.vue';
import AccountSetup from './login/account_setup.vue'
import LoginClyde from './login/login_clyde.vue'
import ErrorScreen from './errors/error_screen.vue'

const loginRoutes = [
  { path: 'forgot', component: ForgotPassword },
  { path: 'new', component: CreateAccount},
  { path: 'password-reset', component: NewPassword },
  { path: 'setup', component: AccountSetup },
  { path: 'clyde', component: LoginClyde },
  { path: '', component: PlanLogin, name: "login" },
]

// admin
import AdminComponent from './administration/admin_component.vue';
import AdminConfigurationsComponent from './administration/admin_configurations.vue';

import AdminRegistrationsComponent from './administration/admin_registrations.vue';

import PlayGroundComponent from './administration/playground_component.vue';

// people
import PeopleScreen from './people/people-screen.vue';
import PeopleList from './people/people_list.vue';
import PersonTabs from './people/person_tabs.vue';

// profile
import ProfileScreen from './profile/profile-screen.vue';

const profileRoutes = [
  // { path: 'session-selection', component: PersonTabs, props: {tab: 'session-selection'} },
  // { path: 'session-ranking', component: PersonTabs, props: {tab: 'session-ranking'} },
  // { path: 'availability', component: PersonTabs, props: {tab: 'availability'} },
  // { path: 'other', component: PersonTabs, props: {tab: 'other'} },
  { path: ':tab', component: PersonTabs, props: true },
  { path: '', component: PersonTabs, props: true }
]

const personRoutes = [
  { path: 'edit/:id', component: PersonTabs, props: true },
  { path: ':tab/:id', component: PersonTabs, props: true },
  // { path: 'session-selection/:id', component: PersonTabs, props: route => ({id: route.params.id, tab: 'session-selection'}) },
  // { path: 'session-ranking/:id', component: PersonTabs, props: route => ({id: route.params.id, tab: 'session-ranking'}) },
  // { path: 'availability/:id', component: PersonTabs, props: route => ({id: route.params.id, tab: 'availability'}) },
  // { path: 'other/:id', component: PersonTabs, props: route => ({id: route.params.id, tab: 'other'}) },
  { path: '', component: PeopleList }
]

//
//import SessionsScreen from './sessions/session_screen.vue';
import SessionList from './sessions/sessions-list.vue';
import SessionTabs from  './sessions/session_tabs.vue';
import SessionScreen from './sessions/session_screen.vue';

//
import ScheduleScreen from './schedule/schedule_screen.vue';

//
import ReportsScreen from './reports/reports_screen.vue'

// surveys
import SurveyScreen from './surveys/survey-screen.vue';
import SurveyList from './surveys/survey-list.vue';
import ManageSurvey from './surveys/manage-survey.vue';
import TakeSurvey from './surveys/take-survey.vue';
import SurveyPage from './surveys/survey-page.vue';
import SurveyThankYou from './surveys/survey-thank-you.vue';

const surveyRoutes = [
  { path: 'edit/:id/:responses', component: ManageSurvey, props: true, name: 'survey_responses'},
  { path: 'edit/:id', component: ManageSurvey, props: true },
  { path: ':surveyId/page/:id/:preview', component: SurveyPage, props: true},
  { path: ':surveyId/page/:id', component: SurveyPage, props: true},
  { path: ':id/thankyou', component: SurveyThankYou, props: true},
  { path: ':id/:preview', component: TakeSurvey, props: true },
  { path: ':id', component: TakeSurvey, props: true},
  { path: '', component: SurveyList },
]

const sessionRoutes = [
  // { path: 'edit/:id', component: SessionTabs, props: route => ({id: route.params.id, tab: 'edit'}) },
  // { path: 'assignment/:id', component: SessionTabs, props: route => ({id: route.params.id, tab: 'assignment'}) },
  // { path: 'schedule/:id', component: SessionTabs, props: route => ({id: route.params.id, tab: 'schedule'}) },
  // { path: 'notes/:id', component: SessionTabs, props: route => ({id: route.params.id, tab: 'notes'}) },
  { path: ':tab/:id', component: SessionTabs, props: true },
  { path: '', component: SessionList },
]

// rbac
import RbacScreen from './rbac/rbac-screen.vue';

// dashboard
import Dashboard from './dashboard/dashboard.vue';

import VenueManager from './venues/venue_manager.vue';

// main
import Vue from 'vue';
import VueRouter from 'vue-router';
import { GET_SESSION_USER, SET_SESSION_USER } from './store/person_session.store';
Vue.use(VueRouter);
// var ua='', signed_agreements={}, doing_agreements=false;
var con_roles=[], isAdmin=false, hasPowers=false;

export const router = new VueRouter({
  scrollBehavior(to) {
    // console.log(to)
    if (to.hash) {
      setTimeout(() => {
        const element = document.getElementById(to.hash.replace(/#/, ''))
        if (element && element.scrollIntoView) {
          element.scrollIntoView({block: 'start'})
        }
      }, 10)
    }
  },
  routes: [
    {
      path: '/login',
      component: LoginScreen,
      children: loginRoutes,
      meta: {
        guest: true
      },
      props: route => ({ redirect: route.query.redirect })
    },
    {
      path: '/error/:code',
      component: ErrorScreen,
      meta: {
        guest: true
      },
      props: true
    },
    // {
    //   path: '/agreements',
    //   component: Agreements,
    //   meta: {
    //     // requiresAuth: true
    //   }
    // },
    {
      path: '/playground',
      component: PlayGroundComponent,
      meta: {
        requiresAuth: true,
        requiresAdmin : true
      }
    },
    {
      path: '/admin',
      component: AdminComponent,
      meta: {
        requiresAuth: true,
        requiresAdmin: true
      }
    },
    {
      path: '/admin-configurations',
      component: AdminConfigurationsComponent,
      meta: {
        requiresAdmin: true,
        requiresAuth: true
      }
    },
    {
      path: '/admin-registrations',
      component: AdminRegistrationsComponent,
      meta: {
        requiresAdmin: true,
        requiresAuth: true
      }
    },
    {
      path: '/people',
      component: PeopleScreen,
      children: personRoutes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/profile',
      component: ProfileScreen,
      children: profileRoutes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/sessions',
      component: SessionScreen,
      children: sessionRoutes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/schedule',
      component: ScheduleScreen,
      // children: sessionRoutes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/surveys',
      component: SurveyScreen,
      children: surveyRoutes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/reports',
      component: ReportsScreen,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/dashboard',
      component: Dashboard,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/rbac',
      component: RbacScreen,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/venues',
      component: VenueManager,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '',
      redirect: '/dashboard'
    }
  ]
});

import { http } from './http';

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // GET SESSION USER only fetches if we don't have one :)
    // TODO this might mess up auto-logout we'll see
    router.app.$store.dispatch(GET_SESSION_USER).then((session) => {
      if (!session.id) {
        next({
          path: '/login',
          query: { redirect: to.fullPath }
        })
      } else if (!Object.values(session.convention_roles).length) {
          const body = new FormData();
          body.append("_method", "delete")
          // const headers = {'Authorization': jwtToken()}
          http.post('/auth/sign_out', body).then(() => {
            router.app.$store.commit(SET_SESSION_USER, {});
            next({
              path: '/login',
              query: {redirect: to.fullPath, alert: "no_role"}
            })
          })
      } else {
        if(con_roles.length===0) {
          // todo clean up side effect assignments
          con_roles = Object.values(session.convention_roles).map(v => {
            isAdmin = isAdmin || v.role === "admin";
            hasPowers = isAdmin || v.role === "staff";
            return v.role;
          })
        }
        //
        if (session.has_password) {
          if(to.meta.requiresAdmin && !isAdmin) {
            next({
              path: '/profile',
              query: { redirect: to.fullPath }
            })
          } else if(to.meta.requiresPowers && !hasPowers) {
            next({
              path: '/profile',
              query: { redirect: to.fullPath }
            })
          } else {
            router.app.$refs.planorama.check_signatures()
            next()
          }
        } else {
          // If the user has not set a password then get them to the setup screen to do so
          next({
            path: '/login/setup',
            query: { redirect: to.fullPath }
          })
        }
      }
    }).catch((error) => {
      console.error(error)
      next();
    })


  } else {
    next() // make sure to always call next()!
  }
})
