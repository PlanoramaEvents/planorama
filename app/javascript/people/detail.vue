<template>
  <div class="detail">
    <dl>
      <dt>Nazwa:</dt>
      <dd class="ml-2">{{ selected.name }}</dd>
      <dt>Nazwa sortowana według:</dt>
      <dd class="ml-2">{{ selected.name_sort_by | na_if_empty}}</dd>
      <dt>Potwierdzona nazwa sortowana:</dt>
      <dd class="ml-2">{{ selected.name_sort_by_confirmed ? 'Tak' : 'Nie' }}</dd>
      <dt>Pseudonim:</dt>
      <dd class="ml-2">{{ selected.pseudonym | na_if_empty}}</dd>
      <dt>Pseudonim sortowany według:</dt>
      <dd class="ml-2">{{ selected.pseudonym_sort_by | na_if_empty}}</dd>
      <dt>Potwierdzony pseudonim sortowany:</dt>
      <dd class="ml-2">{{ selected.pseudonym_sort_by_confirmed ? 'Tak' : 'Nie' }}</dd>
      <dt>Biografia:</dt>
      <dd class="ml-2">
        <span v-html="selected.bio" v-if="selected.bio"></span>
        <span v-else>Nie dotyczy</span>
      </dd>
      <dt>Zaimki osobowe:</dt>
      <dd class="ml-2">{{ selected.pronouns | na_if_empty}}</dd>
      <dt>Tytuł zawodowy:</dt>
      <dd class="ml-2">{{ selected.job_title | na_if_empty}}</dd>
      <dt>Organizacja:</dt>
      <dd class="ml-2">{{ selected.organization | na_if_empty}}</dd>
      <dt>Zarejestrowany:</dt>
      <dd class="ml-2">{{ selected.registered ? 'Tak' : 'Nie' }}</dd>
      <dt>Wyraził zgodę:</dt>
      <dd class="ml-2">{{ selected.opted_in ? 'Tak' : 'Nie'}}</dd>
      <dt>Może udostępniać:</dt>
      <dd class="ml-2">{{ selected.can_share ? 'Tak' : 'Nie' }}</dd>
      <dt>Może być fotografowany:</dt>
      <dd class="ml-2">{{ selected.can_photo === "yes" ? 'Tak' : 'Nie' }}</dd>
      <dt>Może być nagrywany:</dt>
      <dd class="ml-2">{{ selected.can_stream === "yes" ? 'Tak' : 'Nie' }}</dd>
      <dt>Może być rejestrowany:</dt>
      <dd class="ml-2">{{ selected.can_record === "yes" ? 'Tak' : 'Nie' }}</dd>
    </dl>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: "Detail",
  mixins: [
    modelMixin
  ],
  data: () => ({
    editable: false,
  }),
  methods: {
  }
}
</script>

<style>

</style>
