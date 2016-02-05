<?php

class RssfuncsTest extends PHPUnit_Framework_TestCase {

  public function testCalculateArticleHash() {
    // Create a stub for the PluginHost class
    $plugin_host = $this->getMockBuilder('PluginHost')
      ->disableOriginalConstructor()
      ->getMock();

    // Configure the stub
    $plugin_host->method('get_plugin_names')
      ->willReturn(array('blagah','gerber'));

    $article = array(
      'feed' => 'feed ignored',
      'feed' => 'feed ignored again',
      'something' => 'blagah',
      'array' => array('blagah', 'gerber')
    );

    $result = calculate_article_hash($article, $plugin_host);

    $this->assertEquals($result, '91de8bc2393d4863156b999bbeaa841294b8ea64');
  }

  public function testUpdateFeedBrowserCache() {
    $result = update_feedbrowser_cache();
    $this->assertEquals($result, 2);
    $result = db_num_rows(db_query('SELECT * FROM ttrss_feedbrowser_cache'));
    $this->assertEquals($result, 2);
  }

}
