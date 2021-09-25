import VuexORM from '@vuex-orm/core';
const database = new VuexORM.Database();

// admin
import { store as admin } from './administration/admin.store';
import { store as agreementStore } from './administration/agreement.store'
import { store as settingsStore } from './administration/configurations.store';

settingsStore.registerAsModuleFor(admin);
agreementStore.registerAsModuleFor(admin);

// people
//import { store  as people } from './people/people.store';
import { Person } from './people/people.model';
database.register(Person);

// store
import { store as surveys } from './surveys/survey.store'

// session
import { store as session } from './session/session.store';

// main
import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);

import { store as appStore } from './store';
export const store = appStore.initialize(Vuex, [VuexORM.install(database)]);
admin.registerAsModuleFor(store);
surveys.registerAsModuleFor(store);
session.registerAsModuleFor(store);

