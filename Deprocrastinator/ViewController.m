//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Max Lettenberger and Chee Vue on 5/18/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *tasks;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSInteger cursor;
@property NSArray *colors;
@property NSIndexPath *_indexPath1;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tasks = [[NSMutableArray alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], nil];

    //Setup Swipe gesture recognizer to handler (IBAction)swipe:
    UISwipeGestureRecognizer *swipePriority = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(swipe:)];
    swipePriority.direction = UISwipeGestureRecognizerDirectionRight;
    [self.table addGestureRecognizer:swipePriority];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.tasks[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self._indexPath1 = indexPath;

    }

    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Delete?";
    alert.message = @"Are you sure you want to delete?";
    [alert addButtonWithTitle:@"No"];
    [alert addButtonWithTitle:@"Yes"];
    alert.delegate = self;
    [alert show];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
}

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    [self.tasks addObject:self.textField.text];
    //NSLog(@"count: %lu",(unsigned long)[self.tasks count]);
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self.table reloadData];

}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{

    if([self.table isEditing])
    {
        [self.table setEditing:NO animated:NO];
        [self.table reloadData];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [self.table setEditing:YES animated:YES];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self.table reloadData];
    }

    // Code to review: 5/19
    if (self.tasks.count == 0) {
        [self.table setEditing:NO animated:NO];
        self.editButton.enabled = YES;
        self.editButton.titleLabel.text = @"Edit";
    }
}

//-(void)swipePriority:(UISwipeGestureRecognizer *)gesture
//{
//    CGPoint location = [gesture locationInView:self.table];
//    NSIndexPath *swipedIndexPath = [self.table indexPathForRowAtPoint:location];
//    UITableViewCell *swipedCell  = [self.table cellForRowAtIndexPath:swipedIndexPath];
//    if (UISwipeGestureRecognizerDirectionRight)
//    {
//        self.cursor -= 1;
//        if (self.cursor < 0) {
//            self.cursor = self.colors.count - 1;
//        }
//        UIColor *color = self.colors[self.cursor];
//        swipedCell.textLabel.textColor = color;
//    }
//}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
    //Get gesture location
    CGPoint gestureLocation = [sender locationInView:self.table];
    //Getting IndexPath for that location in tableview
    NSIndexPath *swipedIndexPath = [self.table indexPathForRowAtPoint:gestureLocation];
    UITableViewCell *swipedCell  = [self.table cellForRowAtIndexPath:swipedIndexPath];
    if (UISwipeGestureRecognizerDirectionRight)
    {
        self.cursor -= 1;
        if (self.cursor < 0) {
            self.cursor = self.colors.count - 1;
        }
        UIColor *color = self.colors[self.cursor];
        swipedCell.textLabel.textColor = color;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *item = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObject:item];
    [self.tasks insertObject:item atIndex:destinationIndexPath.row];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.tasks removeObjectAtIndex:[self._indexPath1 row]];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self._indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
