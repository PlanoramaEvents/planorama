import {PlanoModel, PlanoCollection} from '../model.js';

export const AgreementTarget = {
  MEMBER: 'member',
  STAFF: 'staff',
  ALL: 'all'
}

export class Agreement extends PlanoModel {
  schema() {
    let s = super.schema()
    delete s.id;
    return s;
  }

  defaults() {
    return {
      id: null,
      title: null,
      terms: null,
      type: null,
      created_by: {
        name: null
      },
      updated_by: {
        name: null
      },
      created_at: new Date(),
      updated_at: new Date(),
      lock_version: 0,
      target: AgreementTarget.ALL
    }
  }

  routes() {
    return {
      fetch: '/agreements/{id}',
      create:  '/agreements',
      save:  '/agreements/{id}',
      update: '/agreements/{id}',
      delete: '/agreements/{id}'
    }
  }
}

export class Agreements extends PlanoCollection {
  options() {
    return {
      model: Agreement
    }
  }

  routes() {
    return {
      fetch: '/agreements?perPage={perPage}&sortField={sortField}&sortOrder={sortOrder}&filter={filter}',
    }
  }
}

export class InformationEthicsAgreement extends Agreement {
  defaults() {
    return Object.assign({}, super.defaults(), {
      title: 'Information Ethics Agreement',
      type: 'information_ethics',
      target: AgreementTarget.STAFF
    })
  }

  routes() {
    return {
      fetch: '/agreements/latest?agreement_type={type}',
      create: '/agreements',
      save: '/agreements',
      update: '/agreements',
      delete: '/agreements/{id}'
    }
  }
}
