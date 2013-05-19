//
//  RecommendVC.m
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import "RecommendVC.h"
#import "PSCollectionViewCell.h"
#import "CellView.h"
#import "UIImageView+WebCache.h"
#import "DetailPhotoVC.h"

@interface RecommendVC ()

@end

@implementation RecommendVC
@synthesize collectionView;
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainView)];
    
    collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:collectionView];
    collectionView.collectionViewDelegate = self;
    collectionView.collectionViewDataSource = self;
    collectionView.pullDelegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    collectionView.numColsPortrait = 2;
    collectionView.numColsLandscape = 3;
    
    collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    collectionView.pullBackgroundColor = [UIColor whiteColor];
    collectionView.pullTextColor = [UIColor blackColor];
//    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [headerView setBackgroundColor:[UIColor redColor]];
//    self.collectionView.headerView=headerView;
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    collectionView.loadingView = loadingLabel;
    
    [self loadDataSource];
//    if(!collectionView.pullTableIsRefreshing) {
//        collectionView.pullTableIsRefreshing = YES;
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0];
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self refreshTable];
}
- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    
    [self.items removeAllObjects];
    [self loadDataSource];
    self.collectionView.pullLastRefreshDate = [NSDate date];
    self.collectionView.pullTableIsRefreshing = NO;
    [self.collectionView reloadData];
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    //    [self loadDataSource];
    [self.items addObjectsFromArray:self.items];
    [self.collectionView reloadData];
    self.collectionView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate

- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}
- (void)viewDidUnload
{
    [self setCollectionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    CellView *v = (CellView *)[self.collectionView dequeueReusableView];
    //    if (!v) {
    //        v = [[[PSCollectionViewCell alloc] initWithFrame:CGRectZero] autorelease];
    //    }
    if(v == nil) {
        NSArray *nib =
        [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        v = [nib objectAtIndex:0];
    }
    
    //    [v fillViewWithObject:item];
    
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@", [item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURL *URL = [NSURL URLWithString:[[self.items objectAtIndex:index] objectForKey:@"source"]];
    v.object = item;
    [v.picView  setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"luma.png"]];
    v.titleLabel.text = [item objectForKey:@"title"];
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.items objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    return [CellView heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    // Do something with the tap
    NSLog(@"index is %d",index);
    DetailPhotoVC *detailPhotoCon = [[DetailPhotoVC alloc] initWithNibName:@"DetailPhotoVC" bundle:nil];
    detailPhotoCon.photoId = [NSString stringWithFormat:@"%@", [[self.items objectAtIndex:index] objectForKey:@"id"]];
    [self.navigationController pushViewController:detailPhotoCon animated:YES];
}

- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.items count];
}

- (void)loadDataSource {
    // Request
//    38174691@N00
//    NSString *URLPath = [NSString stringWithFormat:@"http://42.96.187.214/yahoo-hack/?userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]];
    NSString *URLPath = [NSString stringWithFormat:@"http://42.96.187.214/yahoo-hack/?userid=%@", @"38174691@N00"];
    NSLog(@"urlPath is %@", URLPath);
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            if (data == nil) {
                return ;
            }
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"res is %@", res);
//            if (res && [res isKindOfClass:[NSDictionary class]]) {
            if (res && [res isKindOfClass:[NSArray class]]) {
                self.items = res;
//                for (int i = 0; i< [self.items count]; ) {
//                    NSDictionary *oneImg = [self.items objectAtIndex:i];
//                    if ([[oneImg objectForKey:@"width"] floatValue] == 0 )
//                    {
//                        [self.items removeObjectAtIndex:i];
//                        continue;
//                    }
//                    i++;
//                }
//                NSMutableArray *temp = [[NSMutableArray alloc] init];
//                for (int i =0; i< 10; i++)
//                {
//                    [temp addObject:[self.items objectAtIndex:i]];
//                }
//                self.items = temp;
//                NSLog(@"%@", self.items);
                [self dataSourceDidLoad];
            } else {
                [self dataSourceDidError];
            }
        } else {
            [self dataSourceDidError];
        }
    }];
}

- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"数据未能正常获取" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//    [self.collectionView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
