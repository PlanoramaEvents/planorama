import { survey_columns } from './survey';
import { store as planoStore } from '../model.store'
import { Surveys } from './survey'

export const store = planoStore;
store.state.columns = survey_columns;
store.state.collection = new Surveys();
