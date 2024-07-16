import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule, utils } from 'jsonapi-vuex'
import { http } from '../http';
import { getId } from '../utils/jsonapi_utils';
import { of } from 'rxjs';

export const SELECT = 'SELECT';
export const UNSELECT = 'UNSELECT';

export const SELECTED = 'SELECTED';
export const FETCH_SELECTED = 'FETCH SELECTED';
export const FETCH_BY_ID = 'FETCH BY ID'
export const FETCH = 'FETCH';
export const NEW = 'NEW';
export const SAVE = 'SAVE';
export const DELETE = 'DELETE';
export const SEARCH = 'SEARCH';
export const CLEAR = 'CLEAR';

export const UPDATE_ALL = 'UPDATE ALL';

export const PATCH_RELATED = 'PATCH RELATED';
export const PATCH_FIELDS = 'PATCH FIELDS';

// for paged models
export const SET_MODEL_PAGE_SIZE = 'SET MODEL PAGE SIZE';
export const SET_MODEL_PAGE_META = 'SET MODEL PAGE META';
export const SELECT_NEXT = 'SELECT NEXT';
export const SELECT_PREV = 'SELECT PREV';
export const SELECT_FIRST = 'SELECT FIRST';
export const FETCH_NEXT_PAGE = 'FETCH NEXT PAGE';
export const FETCH_PREV_PAGE = 'FETCH PREV PAGE';
export const FULL_TOTAL = 'FULL TOTAL';
export const SELECTED_INDEX = 'SELECTED INDEX';

// people add-ons
import { personStore, personEndpoints } from './person.store';

// agreement add-ons
import { agreementStore, agreementEndpoints } from './agreement.store';

//
import { curatedTagStore, curatedTagEndpoints } from './curated_tag.store';


// venue add-ons
import { roomStore, roomEndpoints } from './room.store';
import { roomSetStore, roomSetEndpoints} from "@/store/room_set.store";
import { venueStore, venueEndpoints} from "@/store/venue.store";

// Page content (html)
import { pageContentStore, pageContentEndpoints } from "@/store/page_content.store";

// Registration Sync Datum/Data
import { registrationSyncDatumStore, registrationSyncDatumEndpoints } from "@/store/registration_sync_datum.store";
import { personSyncDatumStore, personSyncDatumEndpoints, personSyncDatumPageSize } from "@/store/person_sync_datum.store";

// mailings
import { mailingStore, mailingEndpoints } from './mailing.store';

// settings
import { settingsStore } from "@/store/settings.store";

import { searchStateStore } from "@/store/search_state.store";

// session add-ons
import { personSessionStore } from './person_session.store';

// survey add-ons
import { surveyModel } from './survey/survey.model';
import { surveyStore, surveyEndpoints } from './survey/survey.store';

// session add-ons
import { sessionStore, sessionEndpoints } from './session.store';

// area add-ons
import { areaStore, areaEndpoints } from './area.store';

import { formatStore, formatEndpoints } from './format.store';

import { availabilityStore } from './availability.store';

import { sessionConflictStore, sessionConflictEndpoints } from './session_conflict.store';

import { personExclusionStore } from './person_exclusion.store';

import { emailAddressStore, emailAddressEndpoints } from './email_address.store';

import { sessionLimitStore } from './session_limit.store'

// tag add-ons
import { tagStore, tagEndpoints } from './tag.store';

// Parameters and Configs
import { parameterNameStore, parameterNameEndpoints } from './parameter_name.store';
import { configurationStore, configurationEndpoints } from './configuration.store';

// session add-ons
import { sessionAssignmentStore, sessionAssignmentEndpoints } from './session_assignment.store';
import { publishedSessionEndpoints, publishedSessionStore } from './published_session.store';

// global app things
import { appStore } from './app.store';
import { integrationEndpoints, integrationStore } from './integration.store';

// schedule workflow
import { scheduleWorkflowStore, scheduleWorkflowEndpoints } from './schedule_workflow/schedule_workflow.store';
import { personScheduleApprovalStore, personScheduleApprovalEndpoints } from './person_schedule_approval/person_schedule_approval.store';

// publication dates
import { publicationDatesEndpoints, publicationDatesStore } from './publication_dates.store';

import merge from 'lodash.merge'

const endpoints = {
  ...personEndpoints,
  ...agreementEndpoints,
  ...curatedTagEndpoints,
  ...roomEndpoints,
  ...roomSetEndpoints,
  ...venueEndpoints,
  ...pageContentEndpoints,
  ...registrationSyncDatumEndpoints,
  ...personSyncDatumEndpoints,
  ...surveyEndpoints,
  ...mailingEndpoints,
  ...sessionEndpoints,
  ...areaEndpoints,
  ...tagEndpoints,
  ...sessionAssignmentEndpoints,
  ...parameterNameEndpoints,
  ...configurationEndpoints,
  ...emailAddressEndpoints,
  ...sessionConflictEndpoints,
  ...formatEndpoints,
  // ...availabilityEndpoints,
  // ...personExclusionEndpoints,
  ...scheduleWorkflowEndpoints,
  ...personScheduleApprovalEndpoints,
  ...publishedSessionEndpoints,
  ...integrationEndpoints,
  ...publicationDatesEndpoints,
}

const pageSize = {
  ...personSyncDatumPageSize,
}

// NOTE: this is really the store
Vue.use(Vuex)
export const store = new Vuex.Store({
  modules: {
    // TODO: change clearOnUpdate behavoir
    // see the following for table requests ...
    // Remove all records of type 'widget' from the store
    // store.commit('jv/clearRecords', { _jv: { type: 'widget' } })
    jv: jsonapiModule(
      http,
      {
        preserveJson: true,
        clearOnUpdate: false
      }
    )
  },
  state: {
    selected: {
      ...personStore.selected,
      ...agreementStore.selected,
      ...curatedTagStore.selected,
      ...roomStore.selected,
      ...roomSetStore.selected,
      ...venueStore.selected,
      ...pageContentStore.selected,
      ...registrationSyncDatumStore.selected,
      ...personSyncDatumStore.selected,
      ...surveyStore.selected,
      ...mailingStore.selected,
      ...sessionStore.selected,
      ...areaStore.selected,
      ...tagStore.selected,
      ...sessionAssignmentStore.selected,
      ...parameterNameStore.selected,
      ...configurationStore.selected,
      ...sessionConflictStore.selected,
      ...formatStore.selected,
      ...personScheduleApprovalStore.selected,
      ...publishedSessionStore.selected,
      ...publicationDatesStore.selected,
    },
    page: {
      ...personSyncDatumStore.page,
    },
    ...personSessionStore.state,
    ...settingsStore.state,
    ...surveyStore.state,
    ...searchStateStore.state,
    ...availabilityStore.state,
    ...personExclusionStore.state,
    ...emailAddressStore.state,
    ...roomStore.state,
    ...appStore.state,
    ...scheduleWorkflowStore.state,
    ...integrationStore.state,
    ...registrationSyncDatumStore.state,
    ...personSyncDatumStore.state,
    // ...mailingStore.state
  },
  getters: {
    [SELECTED] (state, getters) {
      return ({model}) => {
        if (!state.selected[model]) return undefined;

        let res = getters['jv/get']({_jv: {id: state.selected[model], type: model}})
        if (model === surveyModel) {
          // Deepcopy is a problem for surveys ... so we only do on the select of individual component ...
          // need to also deep copy selected survey when we edit it's attributes.... how????
          return res
        } else {
          // console.debug('**** DEEP COPY ....', model)
          return utils.deepCopy(res)
        }
      }
    },
    [FULL_TOTAL] (state) {
      return ({model}) => {
        return state.page[model].fullTotal;
      }
    },
    [SELECTED_INDEX] (state) {
      return ({model}) => {
        const {perPage, currentPage, correctOrder } = state.page[model] ?? {};
        const selectedId = state.selected[model];
        if(perPage && currentPage && correctOrder && selectedId)  {
          // we can calculate which one this is
          const previousPageCount = perPage * (currentPage - 1);
          const currentIndex = correctOrder.findIndex(id => id === selectedId);
          return previousPageCount + currentIndex;
        }
        // we cannot calculate which one this is, we're missing some data
        return -1;
      }
    },
    ...personStore.getters,
    ...agreementStore.getters,
    ...roomStore.getters,
    ...roomSetStore.getters,
    ...venueStore.getters,
    ...surveyStore.getters,
    ...pageContentStore.getters,
    ...registrationSyncDatumStore.getters,
    ...personSyncDatumStore.getters,
    ...personSessionStore.getters,
    ...mailingStore.getters,
    ...sessionStore.getters,
    ...areaStore.getters,
    ...tagStore.getters,
    ...sessionAssignmentStore.getters,
    ...parameterNameStore.getters,
    ...configurationStore.getters,
    ...searchStateStore.getters,
    ...availabilityStore.getters,
    ...personExclusionStore.getters,
    ...emailAddressStore.getters,
    ...settingsStore.getters,
    ...formatStore.getters,
    ...scheduleWorkflowStore.getters,
    ...integrationStore.getters,
    ...sessionLimitStore.getters,
  },
  plugins: [
    ...surveyStore.plugins
  ],
  mutations: {
    [SELECT] (state, {model, itemOrId}) {
      state.selected[model] = getId(itemOrId);
    },
    [UNSELECT] (state, {model}) {
      state.selected[model] = undefined;
    },
    [SELECT_FIRST] (state, {model}) {
      // this only works if the model is paged
      if(state.page[model].usePaged) {
        state.selected[model] = state.page[model].correctOrder[0];
      }
    },
    [CLEAR] (state, {model}) {
      this.commit('jv/clearRecords', { _jv: { type: model } })
    },
    [SET_MODEL_PAGE_META] (state, {model, meta}) {
      state.page[model] = {
        ...state.page[model],
        ...meta
      };
    },
    [SET_MODEL_PAGE_SIZE] (state, {model, perPage}) {
      state.page[model] ||= {}
      state.page[model].perPage = perPage;
      state.page[model].currentPage = 1;
    },
    ...personSessionStore.mutations,
    ...settingsStore.mutations,
    ...surveyStore.mutations,
    ...searchStateStore.mutations,
    ...roomStore.mutations,
    ...appStore.mutations,
    ...integrationStore.mutations,
    ...registrationSyncDatumStore.mutations,
    ...personSyncDatumStore.mutations,
  },
  actions: {
    /**
     *
     */
    [UPDATE_ALL] (context, {model, ids, attrs}) {
      const config = []
      const path = `/${model}/update_all`
      const apiConf = { method: 'post', url: path }
      config['data'] = {ids: ids, attrs: attrs}
      merge(apiConf, config)

      // Variation of what the jsonapi-vuex does
      return http(
        apiConf
      ).then(
        (results) => {
          let resData = utils.jsonapiToNorm(results.data.data)
          // PROBLEM ????
          context.commit('jv/addRecords', resData)
          utils.processIncludedRecords(context, results)
          resData = utils.checkAndFollowRelationships(context.state, context.getters, resData)
          resData = utils.preserveJSON(resData, results.data)
          return resData
        }
      )
    },

    /**
     * this method isn't in our version of jsonapi-vuex, so we're writing our own
     * right now it only works on one to many
     */
    [PATCH_RELATED] ({dispatch}, {item, parentRelName, childIdName}) {
      let relId = item?._jv?.id
      let rels = item?._jv?.relationships?.[parentRelName]?.data
      if(!rels || !rels.length) {
        // no relationships found, what to do here? returning true for now
        return Promise.resolve(true)
      }
      let itemsToSend = rels.map( r => ({
        // TODO optimistic locking
        [childIdName]: relId,
        _jv: r
      }));
      return Promise.all(itemsToSend.map(i => dispatch('jv/patch', i)))
    },
    /*
      NOTE: The backend will save relationship (tested when it is the 'parent')

      NOTE: the ...attrs is weird, need to do spread in the call as well ...
      Because: this means you could call [NEW]({model, selected: true, arbitrary: 'attributes' })
    */
    [NEW] ({commit, dispatch}, {model, selected = false, relationships = {}, ...attrs}) {
      let newModel = {
        ...attrs,
        _jv: {
          type: model,
          relationships
        }
      }

      return new Promise((res, rej) => {
        dispatch('jv/post', newModel).then((savedModel) => {
          if (selected) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          res(savedModel);
        }).catch(rej);
      });
    },
    [SAVE] ({commit, dispatch}, {model, selected = true, item, params}) {
      if(item._jv) {
        if(!item._jv.type) {
          _jv.type = model
        }
      }
      else {
        item._jv = { type: model }
      }
      let has_lock_version = typeof item.lock_version !== 'undefined';
      let prev_lock_version = has_lock_version ? item.lock_version : null;

      return new Promise((res, rej) => {
        dispatch('jv/patch', [item, {params}]).then((savedModel) => {
          // to get around the fact that the getter returns a copy,
          // re-select the saved model so that the getter updates.
          if(selected) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          if (has_lock_version && (prev_lock_version == savedModel.lock_version)) {
            // On no change return null - NO=OP
            res(null);
          } else {
            res(savedModel);
          }
        }).catch(rej)
      });
    },
    [DELETE] ({dispatch, commit, state}, {model, itemOrId, unselect = true}) {
      return new Promise((res, rej) => {
        dispatch('jv/delete', `${endpoints[model]}/${getId(itemOrId)}`).then((data) => {
          if (unselect && state.selected[model]) {
            commit(UNSELECT, {model})
          }
          res(data)
        }).catch(rej)
      })
    },
    [SEARCH] ({dispatch}, {model, params}) {
      return dispatch('jv/search', [endpoints[model], {params}])
    },
    // need a way to override the default URL
    [FETCH] ({dispatch, state, commit}, {model, url = null, params}) {
      let isPaged = false;
      if (state.page?.[model]?.usePaged) {
        isPaged = true;
        // modify params to fetch paged if they don't have page info already
        let {current_page, perPage} = params ?? {}
        if (!current_page) {
          current_page = state.page[model]?.currentPage ?? 1;
        }
        if (!perPage) {
          perPage = pageSize[model] ?? state.page[model]?.perPage ?? state.perPage ?? 20
          commit(SET_MODEL_PAGE_SIZE, {model, perPage})
        }
        params = {...params, perPage, current_page}
      } 
      if (url) {
        return dispatch('jv/get', [url, {params}])
      } else {
        // return dispatch('jv/get', [endpoints[model], {params}])
        return new Promise((res, rej) => {
          dispatch('jv/get', [endpoints[model], {params}]).then(data => {
            if(isPaged) {
              const meta = {correctOrder:  data._jv.json.data.map(m => m.id)};
              if (typeof data._jv.json.meta !== 'undefined') {
                meta.currentPage = data._jv.json.meta.current_page;
                meta.total = data._jv.json.meta.total;
                meta.fullTotal = data._jv.json.meta.full_total;
              }
              commit(SET_MODEL_PAGE_META, {model, meta})
            }
            res(data);
          }).catch(rej);
        });
      }
    },
    // [CLEAR] ({dispatch}, {model}) {
    //   this.commit('jv/clearRecords', { _jv: { type: model } })
    // },
    [FETCH_SELECTED] ({state, dispatch}, {model}) {
      if (!state.selected[model]) {
        return Promise.reject(`No ${model} selected`)
      }
      return dispatch(FETCH_BY_ID, {model, id: state.selected[model]})
    },
    [FETCH_BY_ID] ({dispatch}, {model, id}) {
      // We do need this - not all fetch by id will be selected models
      return dispatch('jv/get', `${endpoints[model]}/${id}`)
    },
    [FETCH_NEXT_PAGE] ({state, dispatch}, {model, url = null, params}) {
      //model must be paged
      if(state.page[model]?.usePaged) {
        let {currentPage, perPage, fullTotal} = state.page[model];
        // model must have a next page
        if(perPage * currentPage < fullTotal) {
          // now we can fetch the next page
          return dispatch(FETCH, {model, url, params: {...params, current_page: currentPage + 1}})
        } else {
          console.warn("Attempting to fetch next page when there aren't more pages: ", model)
        }
      } else {
        console.warn("Attempting to fetch next page on an unpaged model: ", model);
      }
    },
    [FETCH_PREV_PAGE] ({state, dispatch}, {model, url = null, params}) {
      //model must be paged
      if(state.page[model]?.usePaged) {
        let {currentPage} = state.page[model];
        console.log('fetching previous. current page', currentPage)
        // model must have a next page
        if(currentPage > 1) {
          // now we can fetch the next page
          return dispatch(FETCH, {model, url, params: {...params, current_page: currentPage - 1}})
        } else {
          console.warn("Attempting to fetch prev page when there aren't more pages: ", model)
        }
      } else {
        console.warn("Attempting to fetch prev page on an unpaged model: ", model);
      }
    },
    // this is an action rather than a mutation because we might need to fetch
    [SELECT_NEXT] ({state, dispatch, commit}, {model}) {
      // this currently only works with paged models
      if(state.page[model]?.usePaged) {
        if(state.selected[model]) {
          const selected = state.selected[model];
          let { correctOrder, currentPage, fullTotal, perPage } = state.page[model]; 
          let currentIndex = correctOrder.findIndex((id) => id === selected);
          if(currentIndex === correctOrder.length - 1) {
            if(perPage * currentPage < fullTotal) {
              // need to fetch next
              return new Promise((res, rej) => {
                // no params here, might need to add later
                dispatch(FETCH_NEXT_PAGE, {model}).then((data) => {
                  const itemOrId = data._jv.json.data[0].id;
                  commit(SELECT, {model, itemOrId });
                  res(itemOrId);
                }).catch(rej);
              })
            } else {
              // don't select anything cause it's on the last one, just return the current id
              return of(selected.id);
            }
          } else {
            const itemOrId = correctOrder[currentIndex + 1] 
            commit(SELECT, {model, itemOrId});
            return of(itemOrId);
          }
        } else {
          console.log("Can't select next when there's nothing selected: ", model)
        }
      } else {
        console.warn("Can't select next from unpaged model: ", model)
      }
      // todo what should i be returning here
    },
    // this is an action rather than a mutation because we might need to fetch
    [SELECT_PREV] ({state, dispatch, commit}, {model}) {
      // this currently only works with paged models
      if(state.page[model]?.usePaged) {
        if(state.selected[model]) {
          const selected = state.selected[model];
          let { correctOrder, currentPage } = state.page[model]; 
          let currentIndex = correctOrder.findIndex((id) => id === selected);
          if(currentIndex === 0) {
            if (currentPage > 1) {
              // need to fetch previous
              return new Promise((res, rej) => {
                // no params here, might need to add later
                dispatch(FETCH_PREV_PAGE, {model}).then((data) => {
                  const itemOrId = data._jv.json.data[data._jv.json.data.length - 1].id;
                  commit(SELECT, {model, itemOrId });
                  res(itemOrId);
                }).catch(rej);
              })
            } else {
              // don't select anything cause it's on the first one, just return the current id
              return of(selected.id);
            }
          } else {
            const itemOrId = correctOrder[currentIndex - 1];
            commit(SELECT, {model, itemOrId});
            return of(itemOrId);
          }
        } else {
          console.log("Can't select prev when there's nothing selected: ", model)
        }
      } else {
        console.warn("Can't select prev from unpaged model: ", model)
      }
      // todo what should i be returning here
    },
    [PATCH_FIELDS] ({dispatch, commit}, {model, item, fields=[], selected = true}) {
      // limited field selection
      let smallItem = {
        // always include lock version so that we have optimistic locking
        lock_version: item.lock_version || 0,
        ...fields.map(field => ({[field]: item[field]})).reduce((p, c) => ({...p, ...c}), {}),
        id: item.id,
        _jv: {
          type: model,
          id: item.id
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/patch', smallItem).then((savedModel) => {
          if (selected) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          res(savedModel);
        }).catch(rej);
      });
    },
    ...personSessionStore.actions,
    ...sessionStore.actions,
    ...surveyStore.actions,
    ...personStore.actions,
    ...agreementStore.actions,
    ...roomStore.actions,
    ...roomSetStore.actions,
    ...pageContentStore.actions,
    ...registrationSyncDatumStore.actions,
    ...personSyncDatumStore.actions,
    ...venueStore.actions,
    ...mailingStore.actions,
    ...settingsStore.actions,
    ...searchStateStore.actions,
    ...areaStore.actions,
    ...tagStore.actions,
    ...sessionAssignmentStore.actions,
// actions not defined    ...parameterNameStore.actions,
    ...configurationStore.actions,
    ...availabilityStore.actions,
    ...personExclusionStore.actions,
    ...sessionLimitStore.actions,
    ...emailAddressStore.actions,
    ...sessionConflictStore.actions,
    ...scheduleWorkflowStore.actions,
    ...personScheduleApprovalStore.actions,
    ...integrationStore.actions,
  }
})
