{* Your footer *}
<div class="footerCol"><p><strong>{translate text='Featured Items'}</strong></p>
	<ul>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_summit%3A"Week"'>{translate text='New This Week'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_summit%3A"Month"&amp;filter[]=literary_form_full%3A"Fiction"'>{translate text='New Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_summit%3A"Month"&amp;filter[]=literary_form_full%3A"Non+Fiction"'>{translate text='New Non-Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_summit%3A"Month"&amp;filter[]=format%3A"DVD"'>{translate text='New DVDs'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_summit%3A"Month"&amp;filter[]=format_category%3A"Audio+Books"'>{translate text='New Audio Books &amp; CDs'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Search Options'}</strong></p>
	<ul>
		{if $user}
		<li><a href="{$path}/Search/History">{translate text='Search History'}</a></li>
		{/if}
		<li><a href="{$path}/Search/Results">{translate text='Standard Search'}</a></li>
		<li><a href="{$path}/Search/Advanced">{translate text='Advanced Search'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Find More'}</strong></p>
	<ul>
		<li><a href="http://summitcountylibraries.org/online-resources/">{translate text='Online Resources'}</a></li>
		<li><a href="http://marmot.lib.overdrive.com" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Download Books &amp; More'}</a></li>
		<li><a href="http://summitcountylibraries.org/services/">{translate text='Hours'}</a></li>
		<li><a href="http://summitcountylibraries.org/events/">{translate text='Events'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Need Help?'}</strong></p>
	<ul>
		<li><a href="{$path}/Help/Home?topic=search" onclick="window.open('{$path}/Help/Home?topic=search', 'Help', 'width=625, height=510'); return false;">{translate text='Search Tips'}</a></li>
		<li><a href="{$askALibrarianLink}" rel="external" onclick="window.open(this.href, 'Ask A Librarian', 'width=230, height=260'); return false">{translate text='Ask a Librarian'}</a></li>

		{if isset($illLink)}
				<li><a href="{$illLink}" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Interlibrary Loan'}</a></li>
		{/if}
		{if isset($suggestAPurchaseLink)}
				<li><a href="{$suggestAPurchaseLink}" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Suggest a Purchase'}</a></li>
		{/if}
		<li><a href="{$path}/Help/Home?topic=faq" onclick="window.open('{$path}/Help/Home?topic=faq', 'Help', 'width=625, height=510, scrollbars=yes'); return false;">{translate text='FAQs'}</a></li>
		<li><a href="http://summitcountylibraries.org/contact/">{translate text='Locations &amp; Contact Us'}</a></li>
	</ul>
</div>
<br class="clearer"/>
{if !$productionServer}
<div class='location_info'>{$physicalLocation}</div>
{/if}