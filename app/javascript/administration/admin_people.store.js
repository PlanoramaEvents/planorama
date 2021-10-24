import { people_columns, AdminPeople } from './admin_people';
import { PlanoStore } from '../model.store';

export const store = new PlanoStore('people', new AdminPeople(), people_columns, {}, {}, {}, true);
