// admin
import { store as admin } from './administration/admin.store';
import { store as agreementStore } from './administration/agreement.store'
import { store as settingsStore } from './administration/configurations.store';

settingsStore.registerAsModuleFor(admin);
agreementStore.registerAsModuleFor(admin);

// people
import { store  as people } from './people/people.store';

// store
import { store as surveys } from './surveys/survey.store'

// session
import { store as session } from './session/session.store';

// main
import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);

import { store as appStore } from './store';
export const store = appStore.initialize(Vuex);
admin.registerAsModuleFor(store);
people.registerAsModuleFor(store);
surveys.registerAsModuleFor(store);
session.registerAsModuleFor(store);

