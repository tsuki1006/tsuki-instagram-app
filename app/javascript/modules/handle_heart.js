import $ from 'jquery'
import axios from 'axios'
import Rails from "@rails/ujs"

axios.defaults.headers.common['X-CSRF-Token'] = Rails.csrfToken()

// いいねする
const listenInactiveHeartEvent = () => {
  $('.inactive-heart').on('click', function() {
    const targetArticle = $(this).closest('.article')
    const activeHeart = targetArticle.find('.active-heart')
    const articleId = targetArticle.data('articleId')

    axios.post(`/articles/${articleId}/like`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          activeHeart.removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

// いいねを外す
const listenActiveHeartEvent = () => {
  $('.active-heart').on('click', function() {
    const targetArticle = $(this).closest('.article')
    const inactiveHeart = targetArticle.find('.inactive-heart')
    const articleId = targetArticle.data('articleId')

    axios.delete(`/articles/${articleId}/like`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          inactiveHeart.removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

export {
  listenInactiveHeartEvent,
  listenActiveHeartEvent
}