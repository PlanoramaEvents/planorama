// import { Model } from '@vuex-orm/core';
// import { v4 as uuid } from 'uuid';
//
// export const SELECT = "SELECT";
// export const UNSELECT = "UNSELECT";
//
// // abstract
// export class PlanoModel extends Model {
//
//   static fetch() {
//     console.log("'this' is", this)
//     this.api().get(this.apiEndpoint, {
//       dataTransformer: (response) => {
//         console.log("'this' is", this)
//         if(this.paginated) {
//           return response.data.data
//         }
//         return response.data
//       }
//     })
//   }
//
//   /*
//   ctx:
//     currentPage: number
//     perPage: number
//     filter: value of filter prop
//       note: where can take a filter function
//     sortBy: string
//     sortDesc: boolean
//     apiUrl: value of api-url prop
//   */
//   static provider (ctx) {
//     return this.query()
//       .where(ctx.filter)
//       .orderBy(ctx.sortBy, ctx.sortDesc ? 'desc': 'asc')
//       .limit(perPage)
//       .offset(currentPage * perPage)
//       .get()
//   }
// }
//
// export const planoModelStore = {
//   state: {
//     selectedId: null
//   },
//
//   getters: {
//     selected: (state, getters) => {
//       return getters.find(state.selectedId)
//     }
//   },
//
//   mutations: {
//     [SELECT] (state, id) {
//       state.selectedId = id;
//     },
//     [UNSELECT] (state) {
//       state.selectedId = null;
//     }
//   }
// }
