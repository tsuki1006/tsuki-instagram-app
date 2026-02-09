import $ from 'jquery'
import axios from 'modules/axios'

// いいねする
const listenInactiveHeartEvent = () => {
  $('.inactive-heart').on('click', function() {
    const targetArticle = $(this).closest('.article')
    const activeHeart = targetArticle.find('.active-heart')
    const articleId = targetArticle.data('articleId')

    axios.post(`/api/articles/${articleId}/like`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          activeHeart.removeClass('hidden')
        }
      })
      .catch((e) => {
        if (e.status === 401) {
          window.alert(e.response.data.error)
          window.location.href = '/users/sign_in'
        } else {
          console.log(e)
        }
      })
  })
}

// いいねを外す
const listenActiveHeartEvent = () => {
  $('.active-heart').on('click', function() {
    const targetArticle = $(this).closest('.article')
    const inactiveHeart = targetArticle.find('.inactive-heart')
    const articleId = targetArticle.data('articleId')

    axios.delete(`/api/articles/${articleId}/like`)
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