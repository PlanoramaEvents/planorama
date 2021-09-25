import { Model } from '@vuex-orm/core';
import { v4 as uuid } from 'uuid';

class Person extends Model {
  static entity = 'people'

  static fields () {
    return {
      id: this.uid(() => uuid()),
      name: this.attr(''),
    }
  }
}
