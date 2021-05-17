import axios from 'axios';
import { csrfToken } from '@rails/ujs';

export const http = axios.create({
    headers: {
        'X-CSRF-TOKEN': csrfToken()
    }
})
