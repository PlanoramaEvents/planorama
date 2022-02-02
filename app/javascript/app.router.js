
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

//
import ScheduleScreen from './sessions/schedule-screen.vue';

// surveys
import SurveyScreen from './surveys/survey-screen.vue';
import SurveyList from './surveys/survey-list.vue';
import EditSurvey from './surveys/edit-survey.vue';
import TakeSurvey from './surveys/take-survey.vue';
import SurveyPage from './surveys/survey-page.vue';
import SurveyThankYou from './surveys/survey-thank-you.vue';

const surveyRoutes = [
  { path: 'edit/:id/:responses', component: EditSurvey, props: true},
  { path: 'edit/:id', component: EditSurvey, props: true },
  { path: ':surveyId/page/:id/:preview', component: SurveyPage, props: true},
  { path: ':surveyId/page/:id', component: SurveyPage, props: true},
  { path: ':id/thankyou', component: SurveyThankYou, props: true},
  { path: ':id/:preview', component: TakeSurvey, props: true },
  { path: ':id', component: TakeSurvey, props: true},
  { path: '', component: SurveyList },
]

//import SurveyScreen from './surveys2/survey-screen.vue';

// dashboard
import Dashboard from './dashboard/dashboard.vue';
import Agreements from './agreements/agreements.vue';

// main
import Vue from 'vue';
import VueRouter from 'vue-router';
Vue.use(VueRouter);
var ua='', signed_agreements={}, doing_agreements=false;

export const router = new VueRouter({
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
      path: '/agreements',
      component: Agreements,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/admin',
      component: AdminComponent,
      meta: {
        requiresAuth: true,
        is_admin : true
      }
    },
    {
      path: '/people',
      component: PeopleScreen,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/schedule',
      component: ScheduleScreen,
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
      path: '/dashboard',
      component: Dashboard,
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

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // check if logged in
    // if not, redirect to login page.
    // Get the session from the store and use that to check
    let session = router.app.$store.getters.currentPersonSession
    console.debug('**** Session: ', session )
    if (!session.id) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    } else {
      if (!doing_agreements) {
        // logged in
        // look for unsigned agreements
        //alert("in app_router: "+session.name);
        for (ua in session.unsigned_agreements) {
          alert(ua + ": " + signed_agreements[ua]);
          if (!signed_agreements[ua]) {
            alert(session.unsigned_agreements[ua].title);
            doing_agreements=true;
            next({
              path: '/agreements',
              query: {redirect: to.fullPath}
            });
            signed_agreements[ua] = true;
            break;
          }
        }
      }
      if(!doing_agreements)
        next();
    }
  } else {
    next() // make sure to always call next()!
  }
})

// router.beforeEach((to, from, next) => {
//   if (to.matched.some(record => record.meta.requiresAuth)) {
//     if (localStorage.getItem('jwt') == null) {
//       next({
//         path: '/login',
//         params: { nextUrl: to.fullPath }
//       })
//     } else {
//       let user = JSON.parse(localStorage.getItem('user'))
//       if (to.matched.some(record => record.meta.is_admin)) {
//         if (user.is_admin == 1) {
//           next()
//         } else {
//           next({ name: 'userboard' })
//         }
//       } else {
//         next()
//       }
//     }
//   } else if (to.matched.some(record => record.meta.guest)) {
//     if (localStorage.getItem('jwt') == null) {
//       next()
//     } else {
//       next({ name: 'userboard' })
//     }
//   } else {
//     next()
//   }
// })

// export router
