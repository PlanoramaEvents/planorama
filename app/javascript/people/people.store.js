import { people_columns, People } from './people';
import { PlanoStore } from '../model.store';

export const store = new PlanoStore('people', new People(), people_columns);
