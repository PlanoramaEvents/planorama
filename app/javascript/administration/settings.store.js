import {settings_columns, Settings} from './settings';
import {PlanoStore } from '../model.store';

export const store = new PlanoStore('settings', new Settings(), settings_columns);
