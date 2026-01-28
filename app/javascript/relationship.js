import $ from 'jquery'
import axios from 'modules/axios'

// フォローしていたら'unfollow', フォローしていなければ'follow'を表示
const handleFollowDisplay = (isFollowing) => {
  if (isFollowing) {
    $('.unfollow').removeClass('hidden')
  } else {
    $('.follow').removeClass('hidden')
  }
}

document.addEventListener('turbo:load', () => {

  // フォローの状態を取得
  const accountId =  $('#account_show').data('accountId')
  axios.get(`/accounts/${accountId}/follow`)
    .then((res) => {
      const isFollowing = res.data.isFollowing
      handleFollowDisplay(isFollowing)
    })

  // フォローする
  $('.follow').on('click', function() {
    axios.post(`/accounts/${accountId}/follow`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          $('.unfollow').removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })

  // フォローを外す
  $('.unfollow').on('click', function() {
    axios.post(`/accounts/${accountId}/unfollow`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          $('.follow').removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })

})
