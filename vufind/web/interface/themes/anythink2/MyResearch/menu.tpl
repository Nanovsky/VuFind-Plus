{if $user != false}
  <h2>{translate text='Your Account'}</h2>
  <div id="profileMessages">
    {if $profile.finesval > 0}
        <div class="alignright">
          <span title="Please Contact your local library to pay fines or Charges." style="color:red; font-weight:bold;" onclick="alert('Please Contact your local library to pay fines or Charges.')">Your account has {$profile.fines} in fines.</span>
          {if $showEcommerceLink && $profile.finesval > $minimumFineAmount}
            <div><a href='{$ecommerceLink}'>Click to Pay Fines Online</a></div>
          {/if}
        </div>
    {/if}
    {if $profile.expireclose}<a class="alignright" title="Please contact your local library to have your library card renewed." style="color:green; font-weight:bold;" onclick="alert('Please Contact your local library to have your library card renewed.')" href="#">Your library card will expire on {$profile.expires}.</a>{/if}
  </div>
  <ul>
    <li><a {if $pageTemplate=="favorites.tpl"}class="active"{/if} href="{$path}/MyAccount/Favorites">{translate text='Favorites'}</a></li>
    <li><a {if $pageTemplate=="readingHistory.tpl"}class="active"{/if} href="{$path}/MyAccount/ReadingHistory">{translate text='Checkout History'}</a></li>
    {if $showFines}
    <li><a {if $pageTemplate=="fines.tpl"}class="active"{/if} href="{$path}/MyAccount/Fines">{translate text='Fines and Messages'}</a></li>
    {/if}
    {if $enableMaterialsRequest}
    <li><a {if $pageTemplate=="myMaterialRequests.tpl"}class="active"{/if} href="{$path}/MaterialsRequest/MyRequests">{translate text='Requests'} {if !empty($profile.numMaterialsRequests)}({$profile.numMaterialsRequests}){/if}</a></li>
    {/if}
    <li><a {if $pageTemplate=="profile.tpl"}class="active"{/if} href="{$path}/MyAccount/Profile">{translate text='Profile'}</a></li>
    {* Only highlight saved searches as active if user is logged in: *}
    <li><a {if $user && $pageTemplate=="history.tpl"}class="active"{/if} href="{$path}/Search/History?require_login">{translate text='Saved Searches'}</a></li>
  </ul>
  <h4>Print Titles</h4>
  <ul>
    <li><a {if $pageTemplate=="checkedout.tpl"}class="active"{/if} href="{$path}/MyAccount/CheckedOut">{translate text='Checked Out Items'}{if !empty($profile.numCheckedOut)} ({$profile.numCheckedOut}){/if}</a></li>
    <li><a {if $pageTemplate=="holds.tpl"}class="active"{/if} href="{$path}/MyAccount/Holds">{translate text='Available Holds'}{if !empty($profile.numHoldsAvailable)} ({$profile.numHoldsAvailable}){/if}</a></li>
    <li><a {if $pageTemplate=="holds.tpl"}class="active"{/if} href="{$path}/MyAccount/Holds">{translate text='Unavailable Holds'}{if !empty($profile.numHoldsRequested)} ({$profile.numHoldsRequested}){/if}</a></li>
  </ul>
{/if}
