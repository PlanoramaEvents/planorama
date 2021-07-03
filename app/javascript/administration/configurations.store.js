import {configurations_columns, Configurations} from './configurations';
import {PlanoStore } from '../model.store';

export const store = new PlanoStore('configuration', new Configurations(), configurations_columns);
