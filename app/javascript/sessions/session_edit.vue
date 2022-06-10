<template>
  <div class="detail container-fluid">
    <div class="row">
      <div class="col-12">
        <h2>Basic Information</h2>
        <b-form-group
          label="Interest Instructions"
        >
          <plano-editor
            id="interest-instructions-text"
            v-model="session.instructions_for_interest"
            type='classic'
            @change="saveSession()"
          ></plano-editor>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">

        <b-form-group
          label="Areas"
        >
          <model-select
            v-model="session_areas"
            model="area"
            field="name"
            :multiple="true"
            @change="saveSession()"
          ></model-select>
        </b-form-group>
        <!--
        <b-form-group
          label="Tags"
        >
          <model-tags
            :taggable="true"
            v-model="session_tags"
            model="tag"
            field="name"
            fieldOnly=true
            filter='{"op":"all","queries":[["taggings.taggable_type", "=", "Session"]]}'
            disabled
          ></model-tags>
        </b-form-group>
        -->
      </div>
      <div class="col-6">
        <b-form-group
          label="Format"
        >
          <model-select
            v-model="session.format_id"
            model="format"
            field="name"
            :multiple="false"
            @change="saveSession()"
            :selectSize="4"
          ></model-select>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel } from '@/store/session.store'
import modelUtilsMixin from '@/store/model_utils.mixin';
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import PlanoEditor from '@/components/plano_editor';

export default {
  name: "SessionEdit",
  components: {
    ModelSelect,
    ModelTags,
    PlanoEditor
  },
  mixins: [
    modelUtilsMixin
  ],
  data: () => ({
    editable: false,
    saving: false
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel)
    },
    session_tags: {
      get() {
        return this.session.tag_list
      },
      set(val) {
        this.session.tag_list = val
      }
    },
    session_areas: {
      get() {
        let res = Object.values(this.session.session_areas).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
              obj.area_id
          )
        )

        return res
      },
      set(val) {
        let existingAreas = Object.values(this.session.session_areas)
        let newAreas = val;
        let areasForSaving = [];
        for (let area of newAreas) {
          let existing = existingAreas.find(r => r.area.id === area);
          if(existing) {
            areasForSaving.push(this.buildArea(existing));
          } else {
            areasForSaving.push({area_id: area})
          }
        }
        for (let area of existingAreas) {
          if(!newAreas.includes(area.area.id)) {
            areasForSaving.push({...this.buildArea(area), _destroy: 1})
          }
        }

        this.session.session_areas_attributes = areasForSaving
      }
    }
  },
  methods: {
    edit() {
      this.editable = true
    },
    buildArea(v) {
      return {
        id: v.id,
        area_id: v.area.id
      }
    },
    saveSession() {
      this.save_model(sessionModel, this.session)
    }
  }
}
</script>

<style>

</style>
