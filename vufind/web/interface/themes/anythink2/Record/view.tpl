{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<script type="text/javascript">
{literal}
$(document).ready(function(){
{/literal}
  var id = {$id|escape:"url"}
  var isbn10 = {$isbn10|escape:"url"}
  var upc = {$upc|escape:"url"}
  GetHoldingsInfo(id);

  {if $isbn || $upc}
    GetEnrichmentInfo(id, isbn10, upc);
  {/if}
  {if $isbn}
    GetReviewInfo(id, isbn);
  {/if}
  {if $enablePospectorIntegration == 1}
    GetProspectorInfo(id);
  {/if}
  {if $user}
    redrawSaveStatus();
  {/if}

  {if (isset($title)) }
    alert("{$title}");
  {/if}
{literal}
});

function redrawSaveStatus() {
  getSaveStatus('{/literal}{$id|escape:"javascript"}{literal}', 'saveLink');
}
{/literal}
</script>

{if $error}<p class="error">{$error}</p>{/if}
<div id="sidebar-wrapper"><div id="sidebar">
  <div class="sidegroup" id="titleDetailsSidegroup">
    <div id="image-column">
      {if $user->disableCoverArt != 1}
        <div id="cover">
          <a href="{$bookCoverUrl}">
            <img alt="{translate text='Book Cover'}" class="recordcover" src="{$bookCoverUrl}" />
          </a>
          <div id="goDeeperLink" class="godeeper" style="display:none">
            <a href="{$path}/Record/{$id|escape:"url"}/GoDeeper" onclick="ajaxLightbox('{$path}/Record/{$id|escape}/GoDeeper?lightbox', null,'5%', '90%', 50, '85%'); return false;">
            <img alt="{translate text='Go Deeper'}" src="{$path}/images/deeper.png" /></a>
          </div>
        </div>
      {/if}
      <div class='requestThisLink' id="placeHold{$id|escape:"url"}" style="display:none">
        <a href="{$path}/Record/{$id|escape:"url"}/Hold"><img src="{$path}/interface/themes/default/images/place_hold.png" alt="Place Hold"/></a>
      </div>
      {if $showOtherEditionsPopup}
      <div id="otherEditionCopies">
        <div style="font-weight:bold"><a href="#" onclick="loadOtherEditionSummaries('{$id}', false)">{translate text="Other Formats and Languages"}</a></div>
      </div>
      {/if}
      {if $goldRushLink}
      <div class ="titledetails">
        <a href="{$goldRushLink}">Check for online articles</a>
      </div>
      {/if}
      <div id="myrating" class="stat">
        <div class="statVal">
          <div class="ui-rater">
            <span class="ui-rater-starsOff" style="width:90px;"><span class="ui-rater-starsOn" style="width:63px"></span></span>
          </div>
        </div>
        <script type="text/javascript">
        $(
         function() {literal} { {/literal}
             $('#myrating').rater({literal}{ {/literal} module:'Record', recordId: '{$shortId}', rating:'{$ratingData.average}', postHref: '{$path}/Record/{$id}/AJAX?method=RateTitle'{literal} } {/literal});
           {literal} } {/literal}
        );
        </script>
      </div>
    </div>

    {if $mainAuthor}
    <h4>{translate text='Main Author'}:</h4>
    <ul>
      <li><a href="{$path}/Author/Home?author={$mainAuthor|trim|escape:"url"}">{$mainAuthor|escape}</a></li>
    </ul>
    {/if}
    {if $corporateAuthor}
    <h4>{translate text='Corporate Author'}:</h4>
    <ul>
      <li><a href="{$path}/Author/Home?author={$corporateAuthor|trim|escape:"url"}">{$corporateAuthor|escape}</a></li>
    </ul>
    {/if}

    {if $contributors}
    <h4>{translate text='Contributors'}:</h4>
    <ul>
    {foreach from=$contributors item=contributor name=loop}
      <li><a href="{$path}/Author/Home?author={$contributor|trim|escape:"url"}">{$contributor|escape}</a></li>
    {/foreach}
    </ul>
    {/if}

    {if $published}
    <h4>{translate text='Published'}:</h4>
    <ul>
    {foreach from=$published item=publish name=loop}
      <li>{$publish|escape}</li>
    {/foreach}
    </ul>
    {/if}

    {if $streetDate}
      <h4>{translate text='Street Date'}:</h4>
      <ul>
        <li>{$streetDate|escape}</li>
      </ul>
    {/if}

    {if !empty($recordFormat)}
      <h4>{translate text='Format'}:</h4>
      {if is_array($recordFormat)}
        <ul>
         {foreach from=$recordFormat item=displayFormat name=loop}
           <li><span class="iconlabel {$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat}</span></li>
         {/foreach}
        </ul>
      {else}
        <ul>
          <li><span class="iconlabel {$recordFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$recordFormat}</span></li>
        </ul>
      {/if}
    {/if}

    {if $mpaaRating}
      <h4>{translate text='Rating'}:</h4>
      <ul>
        <li>{$mpaaRating|escape}</li>
      </ul>
    {/if}

    {if $physicalDescriptions}
    <h4>{translate text='Physical Desc'}:</h4>
    <ul>
    {foreach from=$physicalDescriptions item=physicalDescription name=loop}
      <li>{$physicalDescription|escape}</li>
    {/foreach}
    </ul>
    {/if}

    <h4>{translate text='Language'}:</h4>
    <ul>
    {foreach from=$recordLanguage item=lang}
      <li>{$lang|escape}</li>
    {/foreach}
    </ul>

    {if $editionsThis}
    <h4>{translate text='Edition'}:</h4>
    <ul>
    {foreach from=$editionsThis item=edition name=loop}
      <li>{$edition|escape}</li>
    {/foreach}
    </ul>
    {/if}

    {if $isbns}
    <h4>{translate text='ISBN'}:</h4>
    <ul>
    {foreach from=$isbns item=tmpIsbn name=loop}
      <li>{$tmpIsbn|escape}</li>
    {/foreach}
    </ul>
    {/if}

    {if $issn}
    <h4>{translate text='ISSN'}:</h4>
    <ul>
      <li>{$issn}</li>
      {if $goldRushLink}
        <li><a href='{$goldRushLink}' target='_blank'>Check for online articles</a></li>
      {/if}
    </ul>
    {/if}

    {if $upc}
    <h4>{translate text='UPC'}:</h4>
    <ul>
      <li>{$upc|escape}</li>
    </ul>
    {/if}

    {if $series}
    <h4>{translate text='Series'}:</h4>
    <ul>
      {foreach from=$series item=seriesItem name=loop}
        <li><a href="{$path}/Search/Results?lookfor=%22{$seriesItem|escape:"url"}%22&amp;type=Series">{$seriesItem|escape}</a></li>
      {/foreach}
    </ul>
    {/if}

    {if $arData}
      <h4>{translate text='Accelerated Reader'}:</h4>
      <ul>
        <li>{$arData.interestLevel|escape}</li>
        <li>Level {$arData.readingLevel|escape}, {$arData.pointValue|escape} Points</li>
      </ul>
    {/if}

    {if $lexileScore}
      <h4>{translate text='Lexile Score'}:</h4>
      <ul>
        <li>{$lexileScore|escape}</li>
      </ul>
    {/if}
  </div>
  {if $showTagging == 1}
  <div class="sidegroup" id="tagsSidegroup">
    <h4>{translate text="Tags"}</h4>
    <div id="tagList">
      {if $tagList}
      <ul>
        {foreach from=$tagList item=tag name=tagLoop}
          <li><a href="{$path}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape:"html"}</a> ({$tag->cnt})</li>
        {/foreach}
      </ul>
      {else}
        {translate text='No Tags'}, {translate text='Be the first to tag this record!'}
      {/if}
        <a href="{$path}/Resource/AddTag?id={$id|escape:"url"}&amp;source=VuFind" class="tool add"
           onclick="GetAddTagForm('{$id|escape}', 'VuFind'); return false;">{translate text="Add Tag"}</a>
    </div>
  </div>
  {/if}

  <div class="sidegroup" id="similarTitlesSidegroup">
   {* Display either similar tiles from novelist or from the catalog*}
   <div id="similarTitlePlaceholder"></div>
   {if is_array($similarRecords)}
   <div id="relatedTitles">
    <h4>{translate text="Other Titles"}</h4>
    <ul class="similar">
      {foreach from=$similarRecords item=similar}
      <li>
        {if is_array($similar.format)}
          <span class="{$similar.format[0]|lower|regex_replace:"/[^a-z0-9]/":""}">
        {else}
          <span class="{$similar.format|lower|regex_replace:"/[^a-z0-9]/":""}">
        {/if}
        <a href="{$path}/Record/{$similar.id|escape:"url"}">{$similar.title|regex_replace:"/(\/|:)$/":""|escape}</a>
        </span>
        <span style="font-size: 80%">
        {if $similar.author}<br/>{translate text='By'}: {$similar.author|escape}{/if}
        </span>
      </li>
      {/foreach}
    </ul>
   </div>
   {/if}
  </div>

  <div class="sidegroup" id="similarAuthorsSidegroup">
    <div id="similarAuthorPlaceholder"></div>
  </div>

  {if is_array($editions) && !$showOtherEditionsPopup}
  <div class="sidegroup" id="otherEditionsSidegroup">
    <h4>{translate text="Other Editions"}</h4>
      {foreach from=$editions item=edition}
        <h4>
          <a href="{$path}/Record/{$edition.id|escape:"url"}">{$edition.title|regex_replace:"/(\/|:)$/":""|escape}</a>
        </h4>
        <li>
        {if is_array($edition.format)}
          {foreach from=$edition.format item=format}
            <span class="{$format|lower|regex_replace:"/[^a-z0-9]/":""}">{$format}</span>
          {/foreach}
        {else}
          <span class="{$edition.format|lower|regex_replace:"/[^a-z0-9]/":""}">{$edition.format}</span>
        {/if}
        {$edition.edition|escape}
        {if $edition.publishDate}({$edition.publishDate.0|escape}){/if}
        </li>
      {/foreach}
  </div>
  {/if}

  {if $enablePospectorIntegration == 1}
  <div class="sidegroup">
  {* Display in Prospector Sidebar *}
  <div id="inProspectorPlaceholder"></div>
  </div>
  {/if}

  {if $linkToAmazon == 1 && $isbn}
  <div class="titledetails">
    <a href="http://amazon.com/dp/{$isbn|@formatISBN}"> {translate text="View on Amazon"}</a>
  </div>
  {/if}

  {if $classicId}
  <div id="classicViewLink"><a href ="{$classicUrl}/record={$classicId|escape:"url"}" target="_blank">Classic View</a></div>
  {/if}
</div></div>
<div id="main-content" class="full-result-content">
  <div id="record-header">
    <div id="title-container">
      <h1>{$recordTitleSubtitle|regex_replace:"/(\/|:)$/":""|escape}</h1>
      {if !empty($mainAuthor) || !empty($corporateAuthor)}
        <h3>
          {if !empty($mainAuthor)}
          by <a href="{$path}/Author/Home?author={$mainAuthor|escape:"url"}">{$mainAuthor|escape}</a>
          {/if}
          {if !empty($corporateAuthor)}
            {if !empty($mainAuthor)}, {/if}{translate text='Corporate Author'}: <a href="{$path}/Author/Home?author={$corporateAuthor|escape:"url"}">{$corporateAuthor|escape}</a>
          {/if}
        </h3>
      {/if}
    </div>
    <div id="record-title-nav">
      {if isset($previousId)}
        <a class="button" href="{$path}/{$previousType}/{$previousId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$previousIndex}&amp;page={if isset($previousPage)}{$previousPage}{else}{$page}{/if}" title="{if !$previousTitle}{translate text='Previous'}{else}{$previousTitle|truncate:180:"..."}{/if}">&lt; Prev</a>
      {/if}
      {if isset($nextId)}
        <a class="button" href="{$path}/{$nextType}/{$nextId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$nextIndex}&amp;page={if isset($nextPage)}{$nextPage}{else}{$page}{/if}" title="{if !$nextTitle}{translate text='Next'}{else}{$nextTitle|truncate:180:"..."}{/if}">Next &gt;</a>
      {/if}
      {if $lastsearch}
      <div id="returnToSearch">
        <a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text="Return to Search Results"}</a>
      </div>
      {/if}
    </div>
  </div>
  <div id="tools-column">
    <div class="actions-first">
      <div class="actions-save" id="saveLink{if $shortId}{$shortId}{else}{$id|escape}{/if}">
        {if $user}
          <div id="lists{if $shortId}{$shortId}{else}{$id|escape}{/if}"></div>
          <script type="text/javascript">
            getSaveStatuses('{if $shortId}{$shortId}{else}{$id|escape}{/if}');
          </script>
        {/if}
        {if $showFavorites == 1}
          <a class="button" href="{$url}/Resource/Save?id={$id|escape:"url"}&amp;source=VuFind" onclick="getSaveToListForm('{$id}', 'VuFind'); return false;">{translate text='Add to list...'}</a>
        {/if}
      </div>
      {if $enableBookCart}
      <div class="actions-cart">
        <a href="#" class="button" data-summId="{$id|escape}" data-title="{$recordTitleSubtitle|regex_replace:"/(\/|:)$/":""|escape:"javascript"}">Add to cart +</a>
      </div>
      {/if}
    </div>
    <div id="recordTools">
      <ul>
        {if !$tabbedDetails}
          <li><a href="{$path}/Record/{$id|escape:"url"}/Cite" class="cite" id="citeLink" onclick='ajaxLightbox("{$path}/Record/{$id|escape}/Cite?lightbox", "#citeLink"); return false;'>{translate text="Cite this"}</a></li>
        {/if}
        {if $showTextThis == 1}
          <li><a href="{$path}/Record/{$id|escape:"url"}/SMS" class="sms" id="smsLink" onclick='ajaxLightbox("{$path}/Record/{$id|escape}/SMS?lightbox", "#smsLink"); return false;'>{translate text="Text this"}</a></li>
        {/if}
        {if $showEmailThis == 1}
          <li><a href="{$path}/Record/{$id|escape:"url"}/Email" class="mail" id="mailLink" onclick='ajaxLightbox("{$path}/Record/{$id|escape}/Email?lightbox", "#mailLink"); return false;'>{translate text="Email this"}</a></li>
        {/if}
        {if is_array($exportFormats) && count($exportFormats) > 0}
          <li>
            <a href="{$path}/Record/{$id|escape:"url"}/Export?style={$exportFormats.0|escape:"url"}" class="export" onclick="toggleMenu('exportMenu'); return false;">{translate text="Export Record"}</a><br />
            <ul class="menu" id="exportMenu">
              {foreach from=$exportFormats item=exportFormat}
                <li><a {if $exportFormat=="RefWorks"} {/if}href="{$path}/Record/{$id|escape:"url"}/Export?style={$exportFormat|escape:"url"}">{translate text="Export to"} {$exportFormat|escape}</a></li>
              {/foreach}
            </ul>
          </li>
        {/if}
        {*
        {if $showFavorites == 1}
          <li id="saveLink"><a href="{$path}/Record/{$id|escape:"url"}/Save" class="fav" onclick="getSaveToListForm('{$id|escape}', 'VuFind'); return false;">{translate text="Add to favorites"}</a></li>
        {/if}
        *}
        {if !empty($addThis)}
          <li id="addThis"><a class="addThis addthis_button" href="https://www.addthis.com/bookmark.php?v=250&amp;pub={$addThis|escape:"url"}">{translate text='Bookmark'}</a></li>
        {/if}
      </ul>
    </div>
  </div>
  <div id="record-details-column">
    <div id="record-details-header">
      <div id="holdingsSummaryPlaceholder" class="holdingsSummaryRecord"></div>
    </div>
    {if $summary}
    <div class="resultInformation">
      <h4>{translate text='Description'}</h4>
      <div class="recordDescription">
        {if strlen($summary) > 300}
          <span id="shortSummary">
          {$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'|truncate:300}{*Leave unescaped because some syndetics reviews have html in them *}
          <a href='#' onclick='$("#shortSummary").slideUp();$("#fullSummary").slideDown()'>More</a>
          </span>
          <span id="fullSummary" style="display:none">
          {$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'}{*Leave unescaped because some syndetics reviews have html in them *}
          <a href='#' onclick='$("#shortSummary").slideDown();$("#fullSummary").slideUp()'>Less</a>
          </span>
        {else}
          {$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'}{*Leave unescaped because some syndetics reviews have html in them *}
        {/if}
      </div>
    </div>
    {/if}
    {if $wordThinkHeadings}
    <div class="resultInformation">
      <h4>{translate text='Word Think Headings'}</h4>
      <ul>
        {foreach from=$wordThinkHeadings item=wordThinkHeading name=loop}
          <li><a href="{$path}/Search/Results?lookfor=%22{$wordThinkHeading.search|escape:"url"}%22&amp;basicType=Subject">{$wordThinkHeading.title|escape}</a></li>
        {/foreach}
      </ul>
    </div>
    {/if}

    {if $showStrands}
      <div id="relatedTitleInfo" class="ui-tabs">
        <ul>
          <li><a href="#list-similar-titles">Similar Titles</a></li>
          <li><a href="#list-also-viewed">People who viewed this also viewed</a></li>
          <li><a id="list-series-tab" href="#list-series" style="display:none">Also in this series</a></li>
        </ul>

        {assign var="scrollerName" value="SimilarTitles"}
        {assign var="wrapperId" value="similar-titles"}
        {assign var="scrollerVariable" value="similarTitleScroller"}
        {include file=titleScroller.tpl}

        {assign var="scrollerName" value="AlsoViewed"}
        {assign var="wrapperId" value="also-viewed"}
        {assign var="scrollerVariable" value="alsoViewedScroller"}
        {include file=titleScroller.tpl}


        {assign var="scrollerName" value="Series"}
        {assign var="wrapperId" value="series"}
        {assign var="scrollerVariable" value="seriesScroller"}
        {assign var="fullListLink" value="$path/Record/$id/Series"}
        {include file=titleScroller.tpl}

      </div>
      <script type="text/javascript">
      {literal}
        var similarTitleScroller;
        var alsoViewedScroller;

        $(function() {
          $("#relatedTitleInfo").tabs();
          $("#moredetails-tabs").tabs();

          {/literal}
          {if $defaultDetailsTab}
            $("#moredetails-tabs").tabs('select', '{$defaultDetailsTab}');
          {/if}

          similarTitleScroller = new TitleScroller('titleScrollerSimilarTitles', 'SimilarTitles', 'similar-titles');
          similarTitleScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=strands:PROD-2&recordId={$id}&scrollerName=SimilarTitles', false);

          {literal}
          $('#relatedTitleInfo').bind('tabsshow', function(event, ui) {
            if (ui.index == 0) {
              similarTitleScroller.activateCurrentTitle();
            }else if (ui.index == 1) {
              if (alsoViewedScroller == null){
                {/literal}
                alsoViewedScroller = new TitleScroller('titleScrollerAlsoViewed', 'AlsoViewed', 'also-viewed');
                alsoViewedScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=strands:PROD-1&recordId={$id}&scrollerName=AlsoViewed', false);
              {literal}
              }else{
                alsoViewedScroller.activateCurrentTitle();
              }
            }
          });
        });
        {/literal}
      </script>
    {elseif $showSimilarTitles}
      <div id="relatedTitleInfo" class="ui-tabs">
        <ul>
          <li><a href="#list-similar-titles">Similar Titles</a></li>
          <li><a id="list-series-tab" href="#list-series" style="display:none">Also in this series</a></li>
        </ul>

        {assign var="scrollerName" value="SimilarTitlesVuFind"}
        {assign var="wrapperId" value="similar-titles-vufind"}
        {assign var="scrollerVariable" value="similarTitleVuFindScroller"}
        {include file=titleScroller.tpl}

        {assign var="scrollerName" value="Series"}
        {assign var="wrapperId" value="series"}
        {assign var="scrollerVariable" value="seriesScroller"}
        {assign var="fullListLink" value="$path/Record/$id/Series"}
        {include file=titleScroller.tpl}

      </div>
      <script type="text/javascript">
      {literal}
        var similarTitleScroller;
        var alsoViewedScroller;

        $(function() {
          $("#relatedTitleInfo").tabs();
          $("#moredetails-tabs").tabs();

          {/literal}
          {if $defaultDetailsTab}
            $("#moredetails-tabs").tabs('select', '{$defaultDetailsTab}');
          {/if}

          similarTitleVuFindScroller = new TitleScroller('titleScrollerSimilarTitles', 'SimilarTitles', 'similar-titles');
          similarTitleVuFindScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=similarTitles&recordId={$id}&scrollerName=SimilarTitles', false);

          {literal}
          $('#relatedTitleInfo').bind('tabsshow', function(event, ui) {
            if (ui.index == 0) {
              similarTitleVuFindScroller.activateCurrentTitle();
            }
          });
        });
        {/literal}
      </script>
    {else}
      <div id="relatedTitleInfo" style="display:none">
        {assign var="scrollerName" value="Series"}
        {assign var="wrapperId" value="series"}
        {assign var="scrollerVariable" value="seriesScroller"}
        {assign var="fullListLink" value="$path/Record/$id/Series"}
        {include file=titleScroller.tpl}
      </div>
    {/if}

    <div id="moredetails-tabs">
      {* Define tabs for the display *}
      <ul>
        <li><a href="#holdingstab">{translate text="Copies"}</a></li>
        {if $notes}
          <li><a href="#notestab">{translate text="Notes"}</a></li>
        {/if}
        {if $showAmazonReviews || $showStandardReviews}
          <li><a href="#reviewtab">{translate text="Reviews"}</a></li>
        {/if}
        <li><a href="#readertab">{translate text="Reader Comments"}</a></li>
        <li><a href="#citetab">{translate text="Citation"}</a></li>
        <li><a href="#stafftab">{translate text="Staff View"}</a></li>
      </ul>

      {* Display the content of individual tabs *}
      {if $notes}
        <div id ="notestab">
          <ul class='notesList'>
          {foreach from=$notes item=note}
            <li>{$note}</li>
          {/foreach}
          </ul>
        </div>
      {/if}

      <div id="reviewtab">
        <div id="staffReviewtab" >
        {include file="$module/view-staff-reviews.tpl"}
        </div>

        {if $showAmazonReviews || $showStandardReviews}
        <h4>Professional Reviews</h4>
        <div id='reviewPlaceholder'></div>
        {/if}
      </div>

      {if $showComments == 1}
        <div id="readertab">
          <div style ="font-size:12px;" class ="alignright" id="addReview"><span id="userreviewlink" class="add" onclick="$('#userreview{$shortId}').slideDown();">Add a Review</span></div>
          <div id="userreview{$shortId}" class="userreview">
            <span class ="alignright unavailable closeReview" onclick="$('#userreview{$shortId}').slideUp();" >Close</span>
            <div class='addReviewTitle'>Add your Review</div>
            {assign var=id value=$id}
            {include file="$module/submit-comments.tpl"}
          </div>
          {include file="$module/view-comments.tpl"}
        </div>
      {/if}

      <div id="citetab" >
        {include file="$module/cite.tpl"}
      </div>

      <div id="stafftab">
        {include file=$staffDetails}
      </div>

      <div id="holdingstab">
        {if $internetLinks}
        <h3>{translate text="Internet"}</h3>
        {foreach from=$internetLinks item=internetLink}
        {if $proxy}
        <a href="{$proxy}/login?url={$internetLink.link|escape:"url"}">{$internetLink.linkText|escape}</a><br/>
        {else}
        <a href="{$internetLink.link|escape}">{$internetLink.linkText|escape}</a><br/>
        {/if}
        {/foreach}
        {/if}
        <div id="holdingsPlaceholder"></div>
        {if $enablePurchaseLinks == 1 && !$purchaseLinks}
          <div class='purchaseTitle'><a href="#" onclick="return showPurchaseOptions('{$id}');">{translate text='Buy a Copy'}</a></div>
        {/if}
      </div>
    </div> {* End of tabs*}
  </div>
  <script type="text/javascript">
    {literal}
    $(function() {
      $("#moredetails-tabs").tabs();
    });
    {/literal}
  </script>
</div>

{if $showStrands}
<!-- Event definition to be included in the body before the Strands js library -->
<script type="text/javascript">
{literal}
  if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}
  StrandsTrack.push({
     event:"visited",
     item: "{/literal}{$id|escape}{literal}"
  });
{/literal}
</script>
{/if}
