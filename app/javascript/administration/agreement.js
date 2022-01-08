// import {PlanoModel, PlanoCollection} from '../model.js';
import { http } from '../http';

export const AgreementTarget = {
  MEMBER: 'member',
  STAFF: 'staff',
  ALL: 'all'
}

// export class Agreement extends PlanoModel {
//   schema() {
//     let s = super.schema()
//     delete s.id;
//     return s;
//   }
//
//   defaults() {
//     return {
//       id: null,
//       title: null,
//       terms: null,
//       type: null,
//       created_by: {
//         name: null
//       },
//       updated_by: {
//         name: null
//       },
//       created_at: new Date(),
//       updated_at: new Date(),
//       lock_version: 0,
//       target: AgreementTarget.ALL
//     }
//   }
//
//   routes() {
//     return {
//       fetch: '/agreement/{id}',
//       create:  '/agreement',
//       save:  '/agreement/{id}',
//       update: '/agreement/{id}',
//       delete: '/agreement/{id}'
//     }
//   }
// }

// export class Agreements extends PlanoCollection {
//   options() {
//     return {
//       model: Agreement
//     }
//   }
//
//   routes() {
//     return {
//       fetch: '/agreement?perPage={perPage}&sortField={sortField}&sortOrder={sortOrder}&filter={filter}',
//     }
//   }
// }
//
// export class InformationEthicsAgreement extends Agreement {
//   defaults() {
//     return Object.assign({}, super.defaults(), {
//       title: 'Information Ethics Agreement',
//       type: 'information_ethics',
//       target: AgreementTarget.STAFF
//     })
//   }
//
//   sign() {
//     return http.put(`/agreement/sign/${this.id}`)
//   }
//
//   routes() {
//     return {
//       fetch: '/agreement/latest?agreement_type={type}',
//       create: '/agreement',
//       save: '/agreement',
//       update: '/agreement',
//       delete: '/agreement/{id}'
//     }
//   }
// }
