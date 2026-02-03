import $ from 'jquery'
import axios from 'modules/axios'
import {
  listenFollowEvent,
  listenUnfollowEvent
} from 'modules/handle_relationship'

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
  axios.get(`/api/accounts/${accountId}/follow`)
    .then((res) => {
      const isFollowing = res.data.isFollowing
      handleFollowDisplay(isFollowing)
    })

  // フォローする
  listenFollowEvent(accountId)
  // フォローを外す
  listenUnfollowEvent(accountId)

})
